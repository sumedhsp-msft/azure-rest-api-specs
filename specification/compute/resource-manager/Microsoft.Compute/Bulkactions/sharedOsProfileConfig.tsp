import "../Compute/Compute/vmSharedAttributes.tsp";

// The Bulkactions project uses the TypeSpec namespace `Microsoft.Compute`, while
// the shared VM models live in the separate top-level TypeSpec namespace `Compute`
// (emitted under the `Microsoft.Compute` ARM provider). Inside `Microsoft.Compute`
// the bare name `Compute` is shadowed by the enclosing namespace's own leaf name,
// so the shared models cannot be referenced directly from there. Declaring these
// aliases at global scope (this file has no namespace) resolves `Compute` to the
// shared top-level namespace and exposes the reused models to the Bulkactions
// project without redefining them.
alias WindowsConfiguration = Compute.WindowsConfiguration;
alias LinuxConfiguration = Compute.LinuxConfiguration;
