#include "HostDefaults.h"
#include <UefiSecureBoot.h>
#include <Guid/AuthenticatedVariableFormat.h>
#include <Library/SecureBootVariableLib.h>
#include <Library/SecureBootVariableProvisionLib.h>

EFI_STATUS
EFIAPI
UefiMain (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS  Status;
  EFI_STATUS  RestoreStatus;
  UINT8       SetupMode;
  UINTN       Index;
  UINTN       Size;
  EFI_STATUS  (EFIAPI *Enroll[])(VOID) = {
    EnrollDbFromDefault, EnrollDbxFromDefault,
    EnrollKEKFromDefault, EnrollPKFromDefault
  };

  Status = GetSetupMode (&SetupMode);
  if (EFI_ERROR (Status) || (SetupMode != SETUP_MODE)) {
    Print (L"Refusing enrollment: firmware must be in Setup Mode.\n");
    return EFI_ACCESS_DENIED;
  }

  // Preflight every default before any write. Never replace an active database.
  for (Index = 0; Index < ARRAY_SIZE (mHostDefaults); Index++) {
    HOST_DEFAULT *Item = &mHostDefaults[Index];
    Status = CheckHostVariable (
               Item->DefaultName, &gEfiGlobalVariableGuid,
               Item->Data, Item->Size
               );
    if (EFI_ERROR (Status)) {
      Print (L"Missing or mismatched default %s: %r\n", Item->DefaultName, Status);
      return Status;
    }

    Size = 0;
    Status = gRT->GetVariable (Item->ActiveName, Item->ActiveGuid, NULL, &Size, NULL);
    if (Status != EFI_NOT_FOUND) {
      Print (L"Refusing to replace existing or unreadable %s.\n", Item->ActiveName);
      return EFI_ACCESS_DENIED;
    }
  }

  Status = SetSecureBootMode (CUSTOM_SECURE_BOOT_MODE);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  // The generated descriptor order is db, dbx, KEK, PK; PK is always last.
  for (Index = 0; Index < ARRAY_SIZE (mHostDefaults); Index++) {
    HOST_DEFAULT *Item = &mHostDefaults[Index];
    Status = Enroll[Index] ();
    if (!EFI_ERROR (Status)) {
      Status = CheckHostVariable (
                 Item->ActiveName, Item->ActiveGuid, Item->Data, Item->Size
                 );
    }
    if (EFI_ERROR (Status)) {
      Print (L"Enrollment failed at %s: %r. Earlier writes remain; inspect before retry.\n",
             Item->ActiveName, Status);
      break;
    }
  }

  // Always leave Custom Mode, even after a partial failure. Never erase keys.
  RestoreStatus = SetSecureBootMode (STANDARD_SECURE_BOOT_MODE);
  if (EFI_ERROR (RestoreStatus)) {
    Print (L"Failed to restore Standard Mode: %r. Restore it in firmware setup.\n", RestoreStatus);
    return RestoreStatus;
  }
  if (!EFI_ERROR (Status)) {
    Print (L"Active PK, KEK, db and dbx match the host defaults. Verify Secure Boot state after reboot.\n");
  }
  return Status;
}
