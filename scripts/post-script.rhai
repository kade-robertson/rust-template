if variable::get("actions") {
    file::rename("./github-actions/dependabot.yml", "./.github/dependabot.yml");
    file::rename("./github-actions/automerge.yml", "./.github/workflows/automerge.yml");
    file::rename("./github-actions/test.yml", "./.github/workflows/test.yml");
    file::rename("./github-actions/release-please.yml", "./.github/workflows/release-please.yml");
} else {
    file::delete("./.github/");
    file::delete("./release-please-config.json");
    file::delete("./.release-please-manifest.json");
}

if variable::get("docker") {
    if !variable::get("dockeralpine") {
        file::delete("./Dockerfile.alpine");
    }
    if !variable::get("dockerdebian") {
        file::delete("./Dockerfile");
    }
} else {
    file::delete("./.dockerignore");
    file::delete("./Dockerfile");
    file::delete("./Dockerfile.alpine");
}


file::delete("./renovate.json");
if variable::get("renovate") {
    file::delete("./.github/workflows/automerge.yml");
    file::delete("./.github/dependabot.yml");
    file::rename("./configs/renovate.json", "./renovate.json");
}


file::delete("./github-actions/");
file::delete("./scripts/");
file::delete("./configs/");