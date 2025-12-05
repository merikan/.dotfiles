# Custom Commands

This folder is a collection of custom commands for the [Google Gemini CLI](https://github.com/google-gemini/gemini-cli)

## What is 
A **Custom Command** is essentially a reusable **System Prompt** saved as a file (usually `.md` or `.txt`).

Instead of manually typing instructions like *"Act as a Senior Developer"* or *"Summarize this in Swedish"* every time you use the tool, you save those specific instructions into a file inside your configuration folder.

**How it works:**
1.  **The File:** You create a file with your instructions (e.g., `explain-simple.md`).
2.  **The Trigger:** The filename automatically becomes the command keyword.
3.  **The Execution:** When you run `gemini explain-simple "My Question"`, the CLI sends your saved instructions to the model first, ensuring the answer follows your exact rules.

## Collection

I started out with [GoogleCloudPlatform/serverless-production-readiness-java-gcp](https://github.com/GoogleCloudPlatform/serverless-production-readiness-java-gcp/blob/main/genai/gemini-cli-extensions/README.md) custom commands.

