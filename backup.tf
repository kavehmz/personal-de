data "archive_file" "terraform-backup" {
  type = "zip"

  source_dir  = "${path.module}/gcf-state-backup/code"
  output_path = "${path.module}/gcf-state-backup/gcf-state-backup.zip"
}

resource "google_storage_bucket_object" "archive" {
  provider = "google.de"
  name     = "terraform-backup-function-${data.archive_file.terraform-backup.output_sha}.zip"
  bucket   = "kaveh-de"
  source   = "${path.module}/gcf-state-backup/gcf-state-backup.zip"
}

resource "google_cloudfunctions_function" "function" {
  provider              = "google.de"
  name                  = "terraform-state-backup"
  description           = "Backup terraform state on every change"
  available_memory_mb   = 128
  source_archive_bucket = "kaveh-de"
  source_archive_object = "terraform-backup-function-${data.archive_file.terraform-backup.output_sha}.zip"
  trigger_bucket        = "kaveh-de"
  timeout               = 10
  entry_point           = "backupTerraformState"

  #Currently can be only "us-central1"
  region = "us-central1"
}
