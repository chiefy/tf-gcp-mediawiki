variable "project_id" {}
variable "project_name" {}
variable "org_id" {}
variable "billing_account" {}

resource "google_project" "mediawiki" {
  name            = "${var.project_name}"
  project_id      = "${var.project_id}"
  org_id          = "${var.org_id}"
  billing_account = "${var.billing_account}"
  skip_delete     = false
}
