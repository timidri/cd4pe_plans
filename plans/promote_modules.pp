# This plan will promote a list of modules to a specified stage.
# @param modules The array of modules to promote
# @param workspace The workspace the pipelines live in
# @param branch The branch the pipeline triggers on
# @param commit_sha If left empty, the commit of the last pipeline run will be promoted. If specified, that commit (or branch reference) will be promoted. Obviously, specifying the same commit hash (instead a branch) for multiple modules doesn't really make sense.
# @param stage The stage to promote to
# @param cd4pe_host The host running the CD4PE application
# @param cd4pe_email The email address of the CD4PE user
# @param cd4pe_password The CD4PE user password 
# @param targets The node to run the task on
plan cd4pe_plans::promote_modules(
  TargetSpec $targets,
  Array[String[1]] $modules,
  String[1] $workspace,
  String[1] $stage,
  String[1] $branch = 'master',
  Optional[String[1]] $commit_sha = undef,
  Optional[String[1]] $cd4pe_host = $targets,
  String[1] $cd4pe_email,
  Sensitive[String[1]] $cd4pe_password,
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
