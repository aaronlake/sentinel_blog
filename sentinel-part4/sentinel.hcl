policy "restrict-expensive-workspaces" {
  source            = "./restrict-expensive-workspaces/restrict-expensive-workspaces.sentinel"
  enforcement_level = "hard-mandatory"
}