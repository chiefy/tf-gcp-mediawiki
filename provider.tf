// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/gcp.json")}"
  region      = "us-east1"
}
