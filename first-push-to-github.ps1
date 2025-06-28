Clear-Host
Write-Host "Starting GitHub first-time push process..."

$gitignorePath = ".gitignore"
if (!(Test-Path $gitignorePath)) {
    Write-Host "`n.gitignore not found."
    Write-Host "`nChoose a .gitignore type:"
    Write-Host "1 - Flutter"
    Write-Host "2 - Node.js"
    Write-Host "3 - Python"
    Write-Host "4 - Custom (write your own)"
    Write-Host "0 - Skip (create nothing)"
    $choice = Read-Host "Enter your choice [1-4 or 0]"

    switch ($choice) {
        '1' {
            @"
# Flutter
.build/
.dart_tool/
.packages
.pub-cache/
.idea/
*.iml
*.log
*.lock
*.DS_Store
"@ | Out-File $gitignorePath -Encoding utf8
            Write-Host ".gitignore created for Flutter."
        }
        '2' {
            @"
# Node.js
node_modules/
.env
dist/
*.log
"@ | Out-File $gitignorePath -Encoding utf8
            Write-Host ".gitignore created for Node.js."
        }
        '3' {
            @"
# Python
__pycache__/
*.py[cod]
*.env
*.log
venv/
.env/
"@ | Out-File $gitignorePath -Encoding utf8
            Write-Host ".gitignore created for Python."
        }
        '4' {
            $custom = Read-Host "Enter custom .gitignore content (comma-separated)"
            $customLines = $custom -split ',' | ForEach-Object { $_.Trim() }
            $customLines | Out-File $gitignorePath -Encoding utf8
            Write-Host "Custom .gitignore created."
        }
        default {
            Write-Host "Skipped creating .gitignore."
        }
    }
} else {
    Write-Host ".gitignore already exists."
}

$readmePath = "README.md"
if (!(Test-Path $readmePath)) {
    Write-Host "`nCreating README.md..."
    $title = Read-Host "Enter project title"
    $description = Read-Host "Enter short description"
    $installation = Read-Host "Enter install/run instructions (optional)"
    $usage = Read-Host "Enter usage notes (optional)"

    @"
# $title

$description

## Installation
$installation

## Usage
$usage
"@ | Out-File $readmePath -Encoding utf8
    Write-Host "README.md created."
} else {
    Write-Host "README.md already exists."
}

$commitMessage = Read-Host "`nEnter commit message (default = 'Initial commit')"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Initial commit"
}

$branchName = Read-Host "Enter branch name (default = 'main')"
if ([string]::IsNullOrWhiteSpace($branchName)) {
    $branchName = "main"
}

$repoUrl = Read-Host "Enter GitHub repository URL (e.g. https://github.com/username/repo.git)"

Write-Host "Initializing Git repository..."
git init

Write-Host "Staging all files..."
git add .

Write-Host "Creating commit..."
git commit -m "$commitMessage"

Write-Host "Linking to remote repository..."
git remote add origin $repoUrl

Write-Host "Renaming current branch to '$branchName'..."
git branch -M $branchName

Write-Host "Pushing to GitHub..."
git push -u origin $branchName

$open = Read-Host "`nOpen repository in browser? (y/n)"
if ($open -eq 'y' -or $open -eq 'Y') {
    Start-Process $repoUrl
}

Write-Host "`nProject pushed to GitHub successfully!"
