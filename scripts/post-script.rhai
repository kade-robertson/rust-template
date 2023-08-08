if variable::is_set("actions") {
    file::rename("./github-actions/dependabot.yml", "./.github/dependabot.yml");
    file::rename("./github-actions/automerge.yml", "./.github/workflows/automerge.yml");
    file::rename("./github-actions/test.yml", "./.github/workflows/test.yml");
    file::rename("./github-actions/release-please.yml", "./.github/workflows/release-please.yml");
} else {
    file::delete("./.github/");
}


file::delete("./github-actions/");
file::delete("./scripts/");