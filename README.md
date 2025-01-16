Shell script to detect new images uploaded to wizio.azurecr.io. The script assumes that the Azure CLI is installed and configured to interact with the Azure Container Registry (ACR). It periodically checks for new images by comparing the current list of images with a previously saved list.

How It Works:
Fetch Images from ACR:

Uses az acr repository list to fetch the list of images in the Azure ACR.
Check Azure CLI Login:

Ensures the user is logged into Azure CLI; otherwise, prompts them to log in.
Initial Setup:

Saves the current list of images if no previous list exists.
Detect New Images:

Compares the current list with the previously saved list using the comm command.
Outputs any new images to the console and updates the saved list.
Repeatable:

On subsequent runs, it checks for new images and updates the record automatically.
Usage:
Save the script as detect_new_images.sh.

Make it executable:

bash
Copy
Edit
chmod +x detect_new_images.sh
Run the script:

bash
Copy
Edit
./detect_new_images.sh
If no previous list exists, the script sets up the baseline. On subsequent runs, it detects new images uploaded to the ACR.
