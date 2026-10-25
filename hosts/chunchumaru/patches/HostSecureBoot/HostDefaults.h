// Host public signature lists are generated into HostDefaultData.h at build time.
#include <Uefi.h>
#include <Guid/GlobalVariable.h>
#include <Guid/ImageAuthentication.h>
#include <Library/BaseMemoryLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiLib.h>
#include <Library/UefiRuntimeServicesTableLib.h>

typedef struct {
  CHAR16    *DefaultName;
  CHAR16    *ActiveName;
  EFI_GUID  *ActiveGuid;
  UINT8     *Data;
  UINTN     Size;
} HOST_DEFAULT;

#include "HostDefaultData.h"

// Compare payloads, not efivarfs attribute prefixes or re-encoded certificates.
STATIC
EFI_STATUS
CheckHostVariable (
  IN CHAR16    *Name,
  IN EFI_GUID  *Guid,
  IN UINT8     *Expected,
  IN UINTN     ExpectedSize
  )
{
  EFI_STATUS  Status;
  VOID        *Data;
  UINTN       Size;

  Data = NULL;
  Status = GetVariable2 (Name, Guid, &Data, &Size);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  if ((Size != ExpectedSize) ||
      (CompareMem (Data, Expected, ExpectedSize) != 0)) {
    Status = EFI_SECURITY_VIOLATION;
  }

  if (Data != NULL) {
    FreePool (Data);
  }
  return Status;
}
