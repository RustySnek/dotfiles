/* SPDX-License-Identifier: MIT
 * Isolated KVM regression probe: ICEBP must save the following EIP even
 * when delivery of #DB faults on an unmapped second-level stack page.
 * Run on the AMD host; this creates a tiny guest and touches no VM disks.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/kvm.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>
#define CHECK(x) do { if (!(x)) { perror(#x); exit(2); } } while (0)
static struct kvm_segment seg(int selector, int code) {
 return (struct kvm_segment){.base=0,.limit=0xffffffff,.selector=selector,.type=code?11:3,.present=1,.dpl=0,.db=1,.s=1,.g=1};
}
int main(void) {
 alarm(60);
 setvbuf(stdout, NULL, _IOLBF, 0);
 int failures=0;
 int kvm=open("/dev/kvm",O_RDWR|O_CLOEXEC); CHECK(kvm>=0);
 CHECK(ioctl(kvm,KVM_GET_API_VERSION,0)==KVM_API_VERSION);
 int vm=ioctl(kvm,KVM_CREATE_VM,0); CHECK(vm>=0);
 unsigned char *mem=mmap(0,0x10000,PROT_READ|PROT_WRITE,MAP_SHARED|MAP_ANONYMOUS,-1,0); CHECK(mem!=MAP_FAILED);
 struct kvm_userspace_memory_region low={.slot=0,.guest_phys_addr=0,.memory_size=0x8000,.userspace_addr=(uintptr_t)mem};
 struct kvm_userspace_memory_region stack={.slot=1,.guest_phys_addr=0x8000,.memory_size=0x1000,.userspace_addr=(uintptr_t)(mem+0x8000)};
 CHECK(!ioctl(vm,KVM_SET_USER_MEMORY_REGION,&low)); CHECK(!ioctl(vm,KVM_SET_USER_MEMORY_REGION,&stack));
 int cpu=ioctl(vm,KVM_CREATE_VCPU,0); CHECK(cpu>=0);
 int size=ioctl(kvm,KVM_GET_VCPU_MMAP_SIZE,0); CHECK(size>0);
 struct kvm_run *run=mmap(0,size,PROT_READ|PROT_WRITE,MAP_SHARED,cpu,0); CHECK(run!=MAP_FAILED);
 /* ICEBP; HLT. Handler records the saved EIP and returns to HLT even if wrong. */
 mem[0x1000]=0xf1; mem[0x1001]=0xf4;
 unsigned char handler[]={0x8b,0x04,0x24,0xa3,0x00,0x40,0x00,0x00,0xc7,0x04,0x24,0x01,0x10,0x00,0x00,0xcf};
 memcpy(mem+0x1100,handler,sizeof(handler));
 uint64_t *gdt=(void*)(mem+0x3000); gdt[1]=0x00cf9b000000ffffULL; gdt[2]=0x00cf93000000ffffULL;
 uint64_t *idt=(void*)(mem+0x2000); idt[1]=0x00008e0000081100ULL;
 struct kvm_sregs sr; CHECK(!ioctl(cpu,KVM_GET_SREGS,&sr));
 sr.cs=seg(8,1); sr.ds=sr.es=sr.fs=sr.gs=sr.ss=seg(16,0);
 sr.gdt.base=0x3000; sr.gdt.limit=23; sr.idt.base=0x2000; sr.idt.limit=255;
 sr.cr0=0x11; sr.cr4=0; sr.efer=0; CHECK(!ioctl(cpu,KVM_SET_SREGS,&sr));
 for(int cold=0;cold<2;cold++) {
  int good=0,bad=0;
  for(int i=0;i<10000;i++) {
   if(cold) { stack.memory_size=0; CHECK(!ioctl(vm,KVM_SET_USER_MEMORY_REGION,&stack)); stack.memory_size=0x1000; CHECK(!ioctl(vm,KVM_SET_USER_MEMORY_REGION,&stack)); }
   *(uint32_t*)(mem+0x4000)=0;
   struct kvm_regs regs={.rip=0x1000,.rsp=0x9000,.rflags=2}; CHECK(!ioctl(cpu,KVM_SET_REGS,&regs));
   int r; do { r=ioctl(cpu,KVM_RUN,0); } while(r<0 && errno==EINTR); CHECK(r==0);
   if(run->exit_reason!=KVM_EXIT_HLT) { fprintf(stderr,"unexpected exit %u\n",run->exit_reason); return 2; }
   uint32_t ip=*(uint32_t*)(mem+0x4000);
   if(ip==0x1001) good++; else {bad++; if(bad<4) printf("%s saved EIP=%#x expected=0x1001\n",cold?"cold":"warm",ip);}
  }
  printf("%s stack: correct=%d incorrect=%d\n",cold?"cold":"warm",good,bad);
  failures += bad;
 }
 munmap(run,size); munmap(mem,0x10000);
 close(cpu); close(vm); close(kvm);
 return failures ? 1 : 0;
}
