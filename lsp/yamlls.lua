return {
  settings = {
    yaml = {
      schemas = {
        ["kubernetes"] = { "k8s/**/*.yaml", "resources/**/*.yaml" },
        -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = { "k8s/*", "resources/*" },
        ["https://raw.githubusercontent.com/cappyzawa/concourse-pipeline-jsonschema/master/concourse_jsonschema.json"] = { "concourse/**/*.yaml" },
        ["http://json.schemastore.org/kustomization"] = { "kustomization.yaml" },
        ["https://json.schemastore.org/github-workflow.json"] = { "/.github/workflows/*" },
      }
    }
  }
}
