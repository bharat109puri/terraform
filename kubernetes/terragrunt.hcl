# vim: set filetype=hcl
include "root" {
  path = find_in_parent_folders("terragrunt_root.hcl")
}
