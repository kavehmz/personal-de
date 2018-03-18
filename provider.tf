provider "google" {
  alias       = "de"
  credentials = "${file("account.json")}"
  project     = "kaveh-de"
  region      = "us-east1"
}

terraform {
  provider = "google.de"

  backend "gcs" {
    project     = "kaveh-de"
    region      = "us-east1"
    credentials = "account.json"
    bucket      = "kaveh-de"
    prefix      = "terraform/state"
  }
}
