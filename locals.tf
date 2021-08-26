locals {
  default_tags = {
    Owner         = "Rodrigo M."
    Environment   = "DEV"
    Accessibility = "Private"
  }
  tags = merge(var.tags, local.default_tags)
}