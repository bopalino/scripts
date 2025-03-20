# A collection of random scripts for public use

Disclaimer: 
Most of these scripts are written for personal use on my Mac and not significantly polished for public use.
The scripts have been written using AI and are not guaranteed to work.
Use at your own risk and do your own diligence before running these scripts.

## vercel/update-from-zip.sh

A script to take the content of a V0 zip file and update a local git repo with the same content.
It add the content to the staging branch so that it can be reviewed before being pushed to the remote repo.

Usage:

```bash
./vercel/update-from-zip.sh <path-to-zip-file> <path-to-local-repo>
```

