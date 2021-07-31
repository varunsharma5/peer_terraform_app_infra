terraform{
  backend "s3" {
  	bucket = "peer.review.02-varun-sharma-bucket"
  	key = "peer.review.02-app-infra-state"
  	region = "ap-south-1"
  }
}
