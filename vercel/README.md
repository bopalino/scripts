# Sync Vercel V0 to Git Workflow and Scripts

Currently, there doesn't seem to be an easy solution [[0]](https://www.reddit.com/r/nextjs/comments/1fzs4ji/how_can_i_import_the_project_i_made_from_v0dev_to/) to add code that you generate in Vercel V0 to a GitHub repository. 
While the team acknowledged the gap and is working on a solution [[1]](https://www.reddit.com/r/vercel/comments/1j0xycj/need_help_in_setting_v0dev_with_github/), I'm sharing my workflow in case it helps somebody else as a temporary solution.

## Approach
My workflow mostly follows the steps outlined in one of the [reddit threads](https://www.reddit.com/r/nextjs/comments/1fzs4ji/how_can_i_import_the_project_i_made_from_v0dev_to/) that suggests downloading a zip file.

On a high level, the approach is:
- Create a new GitHub repository
- Download the zip from V0 and push the contents to the new repo
- Create a new Next.js project in Vercel from that repo

To deploy incremental changes after the initial setup:
- Download a new zip file with the updated version from V0
- Use the sync script to update the content in the staging branch

This allows you to examine the diff between versions before pushing or merging into the main branch.

## Alternative Approaches
- Couldn't find an easy way to attach a Git repo to the Vercel project that is created when "Deploying" directly from V0
- Tried the npx shadcn workflow described in the reddit thread with a new Next.js project initiated through the Vercel UI, but I couldn't get the project to work initially
- Unable to get the Next.js app working locally

I haven't spend significant time on those approaches as I got a workflow that is working well for me.

## Setting up V0 with a GitHub Repo (First-Time Setup)

Here are the steps to add a V0 project to Git for the first time:

1. Download the zip version of your project from Vercel V0
2. Create a new Git repository (e.g., using GitHub's web interface)
3. Unzip the downloaded file
4. Initialize and push the content to your repository:

```bash
git init
git remote add origin https://github.com/username/your-repo.git
git add .
git commit -m 'Initial commit from V0 zip'
git branch -M main
git push -u origin main
```

5. After pushing to Git, go to Vercel and create a new next.js project
6. Connect it to your newly created Git repository
7. Deploy the project to Vercel


## Updating an Existing Repository

After the initial setup, when you make further changes in Vercel V0, you'll need to download a new zip file and update your Git repository. To streamline this process, you can use the provided script to update your repository with new changes from V0.

### [update-from-zip.sh](./update-from-zip.sh)

A script to take the content of a V0 zip file and update a local Git repo with the same content.
It adds the content to a staging branch so that it can be reviewed before being pushed to the remote repo.

#### Usage

```bash
./update-from-zip.sh <path-to-zip-file> <path-to-local-repo>
```

#### Example

```bash
./update-from-zip.sh ~/Downloads/my-v0-project ~/projects/my-git-repo
```

## Workflow Tips

- Always review changes in the staging branch before commiting and merging to your main branch
- Use descriptive commit messages when merging changes from V0

## Resources

- [Reddit: How can I import the project from V0 to Next.js?](https://www.reddit.com/r/nextjs/comments/1fzs4ji/how_can_i_import_the_project_i_made_from_v0dev_to/)
- [Reddit: Setting up V0 with GitHub](https://www.reddit.com/r/vercel/comments/1j0xycj/need_help_in_setting_v0dev_with_github/)