#include "HostDefaults.h"
#include <Library/DebugLib.h>

EFI_STATUS
EFIAPI
HostDefaultsEntryPoint (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  UINTN       Index;
  EFI_STATUS  Status;
  EFI_STATUS  Result;

  Result = EFI_SUCCESS;
  for (Index = 0; Index < ARRAY_SIZE (mHostDefaults); Index++) {
    HOST_DEFAULT *Item = &mHostDefaults[Index];

    Status = CheckHostVariable (
               Item->DefaultName, &gEfiGlobalVariableGuid,
               Item->Data, Item->Size
               );
    if (Status == EFI_NOT_FOUND) {
      // UEFI default databases are volatile, boot-service/runtime variables.
      Status = gRT->SetVariable (
                      Item->DefaultName, &gEfiGlobalVariableGuid,
                      EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
                      Item->Size, Item->Data
                      );
    }

    if (EFI_ERROR (Status)) {
      DEBUG ((DEBUG_ERROR, "Host defaults: %s: %r\n", Item->DefaultName, Status));
      Result = Status;
    }
  }

  // No enrollment here: existing active keys and persistent NVRAM are untouched.
  return Result;
}
