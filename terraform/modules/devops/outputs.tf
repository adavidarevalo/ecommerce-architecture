output "codepipeline_name" {
  description = "CodePipeline name"
  value       = aws_codepipeline.frontend_pipeline.name
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.frontend_build.name
}

output "artifacts_bucket_name" {
  description = "CodePipeline artifacts bucket name"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}