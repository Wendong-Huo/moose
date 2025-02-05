[Mesh]
  type = GeneratedMesh
  dim = 2
  # Yes we want a slightly irregular grid
  nx = 11
  ny = 11
  # We will transfer data to the sub app, and that is currently only
  # supported from a replicated mesh
  parallel_type = replicated
[]

[Variables]
  [u]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
[]

[FVKernels]
  [diff]
    type = FVDiffusion
    variable = u
    coeff = 1
  []
[]

[FVBCs]
  [left]
    type = FVDirichletBC
    variable = u
    boundary = left
    value = 0
  []
  [right]
    type = FVDirichletBC
    variable = u
    boundary = right
    value = 1
  []
[]

[Executioner]
  type = Transient
  num_steps = 1
  dt = 1

  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [sub]
    app_type = MooseTestApp
    positions = '0.5 0.5 0 0.7 0.7 0'
    execute_on = timestep_end
    type = TransientMultiApp
    input_files = sub.i
  []
  [pp_sub]
    app_type = MooseTestApp
    positions = '0.5 0.5 0 0.7 0.7 0'
    execute_on = timestep_end
    type = TransientMultiApp
    input_files = pp_sub.i
  []
[]

[Transfers]
  [sample_transfer]
    source_variable = u
    variable = from_master
    type = MultiAppVariableValueSampleTransfer
    to_multi_app = sub
  []
  [sample_pp_transfer]
      source_variable = u
      postprocessor = from_master
      type = MultiAppVariableValueSamplePostprocessorTransfer
      to_multi_app = pp_sub
  []
[]

[Problem]
  parallel_barrier_messaging = false
[]
