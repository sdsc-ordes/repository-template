primitive Log
  // Simple stupid library function.
  fun apply(env: Env, actor_name: String, msg: String) =>
    env.out.print("[" + actor_name + "] " + msg)
