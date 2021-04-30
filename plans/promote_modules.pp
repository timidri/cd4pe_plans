plan cd4pe_plans::promote_modules(
  Array[String[1]] $modules,
  String[1] $workspace,
  String[1] $stage,
  String[1] $branch = 'master',
  Optional[String[1]] $commit_sha = undef,
  String[1] $cd4pe_host,
  String[1] $cd4pe_email,
  Sensitive[String[1]] $cd4pe_password,
  TargetSpec $targets,
){
  $cd4pe_endpoint = "https://${cd4pe_host}"
  $params = {
    email           => $cd4pe_email,
    password        => $cd4pe_password.unwrap,
    repo_type       => 'module',
    branch_name     => $branch,
    workspace       => $workspace,
    stage_name      => $stage,
    web_ui_endpoint => $cd4pe_endpoint,
    commit_sha      => $commit_sha,
  }

  $modules.each |$module| {
    $repo_params = { repo_name => $module }
    $all_params = $params + $repo_params
    $message = "Promoting ${module} to stage '${params['stage_name']}'"
    $result = run_task('cd4pe::promote_pipeline_to_stage', $targets, $message, $all_params)
    out::message($result)
  }
}
