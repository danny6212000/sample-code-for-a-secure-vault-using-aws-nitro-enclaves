// Reproducible builds configuration
// Set SOURCE_DATE_EPOCH to git commit time for consistent timestamps:
//   export SOURCE_DATE_EPOCH=$(git log -1 --format=%ct)
//   docker buildx bake -f docker-bake.hcl

group "default" {
  targets = ["parent", "enclave"]
}

target "parent" {
  context = "./parent"
  dockerfile = "Dockerfile"
  args = {
    TARGETPLATFORM = "aarch64-unknown-linux-gnu"
  }
  platforms = ["linux/arm64"]
  tags = ["parent-vault:latest"]
  cache-to = ["type=gha,ignore-error=true,mode=max,scope=parent"]
  cache-from = ["type=gha,scope=parent"]
}

target "enclave" {
  context = "./enclave"
  dockerfile = "Dockerfile"
  args = {
    TARGETPLATFORM = "aarch64-unknown-linux-musl"
  }
  platforms = ["linux/arm64"]
  tags = ["enclave-vault:latest"]
  cache-to = ["type=gha,ignore-error=true,mode=max,scope=enclave"]
  cache-from = ["type=gha,scope=enclave"]
}
