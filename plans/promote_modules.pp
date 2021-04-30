plan cd4pe_plans::promote_modules(
  Array[String[1]] $modules,
  String[1] $cd4pe_host,
  String[1] $cd4pe_email,
  Sensitive[String[1]] $cd4pe_password,
  TargetSpec $targets,
){
  $cd4pe_endpoint = "https://${cd4pe_host}"
  $params = {
    email           => $cd4pe_email,
    password        => $cd4pe_password.unwrap,
    repo_name       => 'cd4pe_plans',
    repo_type       => 'module',
    branch_name     => master,
    workspace       => demo,
    stage_name      => 'Deploy to Production Freeze',
    web_ui_endpoint => $cd4pe_endpoint,
    # commit_sha      => '737f6e72b818a3c66aa2f5bed51bd3ac0c40d21c',
  }

  $result = run_task('cd4pe::promote_pipeline_to_stage', $targets, 'Promoting ...', $params)
  out::message($result)
}
