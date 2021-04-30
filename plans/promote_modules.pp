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
    repo_name       => 'control-repo',
    repo_type       => 'control',
    branch_name     => master,
    workspace       => demo,
    stage_name      => 'Deploy to Production Freeze',
    web_ui_endpoint => $cd4pe_endpoint,
    commit_sha      => '737f6e72b818a3c66aa2f5bed51bd3ac0c40d21c',
  }

  $modules.each |$module| {
    $params['repo_name'] = $module
    $result = run_task('cd4pe::promote_pipeline_to_stage', $targets, "Promoting ${module} to ${params['stage_name']}", $params)
    out::message($result)
  }
}
