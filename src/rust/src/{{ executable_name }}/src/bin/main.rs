use clap::Parser;
use anyhow::{Result, anyhow};

/// A simple CLI that says hello.
#[derive(Parser)]
#[clap(author, version, about, long_about = None)]
struct Args {
    /// Name of the person to greet.
    #[clap(short, long, default_value = "World")]
    name: String
}

fn main() -> Result<()> {
    let args = Args::parse();

    if args.name == "crash" {
        return Err(anyhow!("You cannot specify 'crash' as '--name'."))
    }

    println!("Hello, {}!", args.name);
    Ok(())
}
