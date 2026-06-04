import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";
import "../common/models.tsp";

using Versioning;
using Azure.ResourceManager;
using Common;

namespace Compute;
/**
 * Describes a virtual machine scale set OS profile.
 */
model VirtualMachineScaleSetOSProfile {
  /**
   * Specifies the computer name prefix for all of the virtual machines in the scale set. Computer name prefixes must be 1 to 15 characters long.
   */
  computerNamePrefix?: string;

  /**
   * Specifies the name of the administrator account. <br><br> **Windows-only restriction:** Cannot end in "." <br><br> **Disallowed values:** "administrator", "admin", "user", "user1", "test", "user2", "test1", "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console", "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0", "sys", "test2", "test3", "user4", "user5". <br><br> **Minimum-length (Linux):** 1  character <br><br> **Max-length (Linux):** 64 characters <br><br> **Max-length (Windows):** 20 characters
   */
  adminUsername?: string;

  @doc("Specifies the password of the administrator account. <br><br> **Minimum-length (Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters <br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length (Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4 conditions below need to be fulfilled <br> Has lower characters <br>Has upper characters <br> Has a digit <br> Has a special character (Regex match [\\W_]) <br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\", \"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\", \"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to reset the Remote Desktop service or its login password in a Windows VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp) <br><br> For resetting root password, see [Manage users, SSH, and check or repair disks on Azure Linux VMs using the VMAccess Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)")
  @secret
  adminPassword?: string;

  /**
   * Specifies a base-64 encoded string of custom data. The base-64 encoded string is decoded to a binary array that is saved as a file on the Virtual Machine. The maximum length of the binary array is 65535 bytes. For using cloud-init for your VM, see [Using cloud-init to customize a Linux VM during creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init)
   */
  customData?: string;

  /**
   * Specifies Windows operating system settings on the virtual machine.
   */
  windowsConfiguration?: WindowsConfiguration;

  /**
   * Specifies the Linux operating system settings on the virtual machine. For a list of supported Linux distributions, see [Linux on Azure-Endorsed Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
   */
  linuxConfiguration?: LinuxConfiguration;

  /**
   * Specifies set of certificates that should be installed onto the virtual machines in the scale set. To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  @identifiers(#["sourceVault/id"])
  secrets?: VaultSecretGroup[];

  /**
   * Specifies whether extension operations should be allowed on the virtual machine scale set. This may only be set to False when no extensions are present on the virtual machine scale set.
   */
  allowExtensionOperations?: boolean;

  /**
   * Optional property which must either be set to True or omitted.
   */
  requireGuestProvisionSignal?: boolean;
}

/**
 * Specifies Windows operating system settings on the virtual machine.
 */
model WindowsConfiguration {
  /**
   * Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, it is set to true by default. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.
   */
  provisionVMAgent?: boolean;

  /**
   * Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.
   */
  enableAutomaticUpdates?: boolean;

  /**
   * Specifies the time zone of the virtual machine. e.g. "Pacific Standard Time". Possible values can be [TimeZoneInfo.Id](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.id?#System_TimeZoneInfo_Id) value from time zones returned by [TimeZoneInfo.GetSystemTimeZones](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.getsystemtimezones).
   */
  timeZone?: string;

  /**
   * Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup.
   */
  @identifiers(#[])
  additionalUnattendContent?: AdditionalUnattendContent[];

  /**
   * [Preview Feature] Specifies settings related to VM Guest Patching on Windows.
   */
  patchSettings?: PatchSettings;

  /**
   * Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell.
   */
  winRM?: WinRMConfiguration;

  /**
   * Indicates whether VMAgent Platform Updates are enabled for the Windows Virtual Machine.
   */
  @visibility(Lifecycle.Read)
  enableVMAgentPlatformUpdates?: boolean;
}

/**
 * Specifies the Linux operating system settings on the virtual machine. For a list of supported Linux distributions, see [Linux on Azure-Endorsed Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
 */
model LinuxConfiguration {
  /**
   * Specifies whether password authentication should be disabled.
   */
  disablePasswordAuthentication?: boolean;

  /**
   * Specifies the ssh key configuration for a Linux OS.
   */
  ssh?: SshConfiguration;

  /**
   * Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.
   */
  provisionVMAgent?: boolean;

  /**
   * [Preview Feature] Specifies settings related to VM Guest Patching on Linux.
   */
  patchSettings?: LinuxPatchSettings;

  /**
   * Indicates whether VMAgent Platform Updates is enabled for the Linux virtual machine. Default value is false.
   */
  enableVMAgentPlatformUpdates?: boolean;
}

/**
 * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of patches to a virtual machine. You do this by applying patches manually inside the VM. In this mode, automatic updates are disabled; the property WindowsConfiguration.enableAutomaticUpdates must be false<br /><br /> **AutomaticByOS** - The virtual machine will automatically be updated by the OS. The property WindowsConfiguration.enableAutomaticUpdates must be true. <br /><br /> **AutomaticByPlatform** - the virtual machine will automatically updated by the platform. The properties provisionVMAgent and WindowsConfiguration.enableAutomaticUpdates must be true
 */
union WindowsVMGuestPatchMode {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Manual: "Manual",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AutomaticByOS: "AutomaticByOS",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AutomaticByPlatform: "AutomaticByPlatform",
}

/**
 * Specifies the mode of VM Guest patch assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine.<br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
 */
union WindowsPatchAssessmentMode {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ImageDefault: "ImageDefault",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AutomaticByPlatform: "AutomaticByPlatform",
}

/**
 * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
 */
union WindowsVMGuestPatchAutomaticByPlatformRebootSetting {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Unknown: "Unknown",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  IfRequired: "IfRequired",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Never: "Never",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Always: "Always",
}

/**
 * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - The virtual machine's default patching configuration is used. <br /><br /> **AutomaticByPlatform** - The virtual machine will be automatically updated by the platform. The property provisionVMAgent must be true
 */
union LinuxVMGuestPatchMode {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ImageDefault: "ImageDefault",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AutomaticByPlatform: "AutomaticByPlatform",
}

/**
 * Specifies the mode of VM Guest Patch Assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine. <br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
 */
union LinuxPatchAssessmentMode {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ImageDefault: "ImageDefault",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AutomaticByPlatform: "AutomaticByPlatform",
}

/**
 * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
 */
union LinuxVMGuestPatchAutomaticByPlatformRebootSetting {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Unknown: "Unknown",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  IfRequired: "IfRequired",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Never: "Never",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Always: "Always",
}

/**
 * Specifies the name of the setting to which the content applies. Possible values are: FirstLogonCommands and AutoLogon.
 */
#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"
enum SettingNames {
  AutoLogon,
  FirstLogonCommands,
}

/**
 * Specifies the protocol of WinRM listener. Possible values are: **http,** **https.**
 */
#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"
enum ProtocolTypes {
  Http,
  Https,
}

/**
 * Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied.
 */
model AdditionalUnattendContent {
  /**
   * The pass name. Currently, the only allowable value is OobeSystem.
   */
  passName?: PassNames;

  /**
   * The component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup.
   */
  componentName?: ComponentNames;

  /**
   * Specifies the name of the setting to which the content applies. Possible values are: FirstLogonCommands and AutoLogon.
   */
  settingName?: SettingNames;

  /**
   * Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted.
   */
  content?: string;
}

/**
 * The component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup.
 */
#suppress "@azure-tools/typespec-azure-core/no-closed-literal-union"
union ComponentNames {
  #suppress "@azure-tools/typespec-azure-core/documentation-required"
  "Microsoft-Windows-Shell-Setup",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required"
#suppress "@azure-tools/typespec-azure-core/no-closed-literal-union"
union PassNames {
  #suppress "@azure-tools/typespec-azure-core/documentation-required"
  "OobeSystem",
}

/**
 * Specifies settings related to VM Guest Patching on Windows.
 */
model PatchSettings {
  /**
   * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of patches to a virtual machine. You do this by applying patches manually inside the VM. In this mode, automatic updates are disabled; the property WindowsConfiguration.enableAutomaticUpdates must be false<br /><br /> **AutomaticByOS** - The virtual machine will automatically be updated by the OS. The property WindowsConfiguration.enableAutomaticUpdates must be true. <br /><br /> **AutomaticByPlatform** - the virtual machine will automatically updated by the platform. The properties provisionVMAgent and WindowsConfiguration.enableAutomaticUpdates must be true
   */
  patchMode?: WindowsVMGuestPatchMode;

  /**
   * Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'.
   */
  enableHotpatching?: boolean;

  /**
   * Specifies the mode of VM Guest patch assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine.<br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
   */
  assessmentMode?: WindowsPatchAssessmentMode;

  /**
   * Specifies additional settings for patch mode AutomaticByPlatform in VM Guest Patching on Windows.
   */
  automaticByPlatformSettings?: WindowsVMGuestPatchAutomaticByPlatformSettings;
}

/**
 * Specifies additional settings to be applied when patch mode AutomaticByPlatform is selected in Windows patch settings.
 */
model WindowsVMGuestPatchAutomaticByPlatformSettings {
  /**
   * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
   */
  rebootSetting?: WindowsVMGuestPatchAutomaticByPlatformRebootSetting;

  /**
   * Enables customer to schedule patching without accidental upgrades
   */
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

/**
 * Describes Windows Remote Management configuration of the VM
 */
model WinRMConfiguration {
  /**
   * The list of Windows Remote Management listeners
   */
  @identifiers(#[])
  listeners?: WinRMListener[];
}

/**
 * Describes Protocol and thumbprint of Windows Remote Management listener
 */
model WinRMListener {
  /**
   * Specifies the protocol of WinRM listener. Possible values are: **http,** **https.**
   */
  protocol?: ProtocolTypes;

  /**
   * This is the URL of a certificate that has been uploaded to Key Vault as a secret. For adding a secret to the Key Vault, see [Add a key or secret to the key vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add). In this case, your certificate needs to be the Base64 encoding of the following JSON Object which is encoded in UTF-8: <br><br> {<br>  "data":"<Base64-encoded-certificate>",<br>  "dataType":"pfx",<br>  "password":"<pfx-file-password>"<br>} <br> To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  certificateUrl?: string;
}

/**
 * SSH configuration for Linux based VMs running on Azure
 */
model SshConfiguration {
  /**
   * The list of SSH public keys used to authenticate with linux based VMs.
   */
  @identifiers(#["path"])
  publicKeys?: SshPublicKey[];
}

/**
 * Contains information about SSH certificate public key and the path on the Linux VM where the public key is placed.
 */
model SshPublicKey {
  /**
   * Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file. Example: /home/user/.ssh/authorized_keys
   */
  path?: string;

  /**
   * SSH public key certificate used to authenticate with the VM through ssh. The key needs to be at least 2048-bit and in ssh-rsa format. For creating ssh keys, see [Create SSH keys on Linux and Mac for Linux VMs in Azure]https://docs.microsoft.com/azure/virtual-machines/linux/create-ssh-keys-detailed).
   */
  keyData?: string;
}

/**
 * Specifies settings related to VM Guest Patching on Linux.
 */
model LinuxPatchSettings {
  /**
   * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - The virtual machine's default patching configuration is used. <br /><br /> **AutomaticByPlatform** - The virtual machine will be automatically updated by the platform. The property provisionVMAgent must be true
   */
  patchMode?: LinuxVMGuestPatchMode;

  /**
   * Specifies the mode of VM Guest Patch Assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine. <br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
   */
  assessmentMode?: LinuxPatchAssessmentMode;

  /**
   * Specifies additional settings for patch mode AutomaticByPlatform in VM Guest Patching on Linux.
   */
  automaticByPlatformSettings?: LinuxVMGuestPatchAutomaticByPlatformSettings;
}

/**
 * Specifies additional settings to be applied when patch mode AutomaticByPlatform is selected in Linux patch settings.
 */
model LinuxVMGuestPatchAutomaticByPlatformSettings {
  /**
   * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
   */
  rebootSetting?: LinuxVMGuestPatchAutomaticByPlatformRebootSetting;

  /**
   * Enables customer to schedule patching without accidental upgrades
   */
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

/**
 * Describes a set of certificates which are all in the same Key Vault.
 */
model VaultSecretGroup {
  /**
   * The relative URL of the Key Vault containing all of the certificates in VaultCertificates.
   */
  sourceVault?: SubResource;

  /**
   * The list of key vault references in SourceVault which contain certificates.
   */
  @identifiers(#["certificateUrl"])
  vaultCertificates?: VaultCertificate[];
}

/**
 * Describes a single certificate reference in a Key Vault, and where the certificate should reside on the VM.
 */
model VaultCertificate {
  /**
   * This is the URL of a certificate that has been uploaded to Key Vault as a secret. For adding a secret to the Key Vault, see [Add a key or secret to the key vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add). In this case, your certificate needs to be It is the Base64 encoding of the following JSON Object which is encoded in UTF-8: <br><br> {<br>  "data":"<Base64-encoded-certificate>",<br>  "dataType":"pfx",<br>  "password":"<pfx-file-password>"<br>} <br> To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  certificateUrl?: string;

  /**
   * For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name &lt;UppercaseThumbprint&gt;.crt for the X509 certificate file and &lt;UppercaseThumbprint&gt;.prv for private key. Both of these files are .pem formatted.
   */
  certificateStore?: string;
}
