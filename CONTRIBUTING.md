# Contributing to VMware VMXNET3 Link Speed Tool

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use the issue template** when creating new issues
3. **Provide detailed information**:
   - PowerShell version
   - PowerCLI version
   - vSphere version
   - Error messages (full stack trace)
   - Steps to reproduce

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes**
4. **Test your changes** (see Testing section)
5. **Commit with clear messages**
6. **Push to your fork**
7. **Create a Pull Request**

## Development Setup

### Prerequisites
- PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform)
- VMware PowerCLI
- Pester (for testing)
- PSScriptAnalyzer (for linting)

### Installation
```powershell
# Install development dependencies
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name Pester -Scope CurrentUser
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
```

## Testing

### Running Tests
```powershell
# Run all tests
Invoke-Pester -Path tests -Output Detailed

# Run specific test file
Invoke-Pester -Path tests/vmware-vm-vmxnet3-link-speed.Tests.ps1
```

### Code Quality
```powershell
# Run PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path . -Settings ./.config/PSScriptAnalyzerSettings.psd1 -Recurse
```

### Test Coverage
- All new functions must have corresponding tests
- Aim for meaningful test coverage, not just line coverage
- Include both positive and negative test cases

## Coding Standards

### PowerShell Style Guide
- Use **4 spaces** for indentation
- **PascalCase** for functions and parameters
- **camelCase** for variables
- **UPPERCASE** for constants
- Use **approved verbs** for function names

### Documentation
- Add **comment-based help** for all functions
- Update **README.md** for user-facing changes
- Include **examples** for new features

### Error Handling
- Use `try/catch` blocks for error handling
- Provide **meaningful error messages**
- Use appropriate **ErrorAction** parameters

## Pull Request Guidelines

### Before Submitting
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] Commit messages are clear and descriptive

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tests added/updated
- [ ] Manual testing completed
- [ ] No breaking changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
```

## Release Process

### Versioning
We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist
1. Update version in script header
2. Update CHANGELOG.md
3. Create release tag
4. Update documentation

## Getting Help

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas

### Development Questions
- Check existing issues and discussions
- Review documentation and examples
- Test in isolated environment first

## Recognition

Contributors will be acknowledged in:
- README.md contributors section
- Release notes
- Git commit history

Thank you for contributing to make this tool better for the VMware community!