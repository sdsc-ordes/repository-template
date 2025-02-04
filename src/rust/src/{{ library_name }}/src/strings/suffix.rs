/// Checks if `s` contains the suffix `suffix`.
pub fn has_suffix(s: impl AsRef<str>, suffix: impl AsRef<str>) -> bool  {
    s.as_ref().ends_with(suffix.as_ref())
}

#[cfg(test)]
mod tests {
    use anyhow::{Result};
    use super::has_suffix;

    #[test]
    fn test_has_suffix() -> Result<()> {
        assert_eq!(has_suffix("banana.exe", ".exe"), true, "Suffix not '.exe'");
        Ok(())
    }
}
