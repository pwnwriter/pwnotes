# Setting Up Google Authentication for SSH on a Linux Server

## Step 1: Install Google Authenticator

1. **Update your package list:**

    ```bash
    sudo apt update
    ```

2. **Install the Google Authenticator package:**

    ```bash
    sudo apt install libpam-google-authenticator
    ```

## Step 2: Configure Google Authenticator for Your User

1. **Run the Google Authenticator setup:**

    ```bash
    google-authenticator
    ```

2. **Answer the prompts:**

    - **"Do you want authentication tokens to be time-based (y/n)?"**: Type `y` and press Enter.
    - **Backup Codes**: Write down the emergency scratch codes provided and store them in a safe place.
    - **"Do you want me to update your "/home/username/.google_authenticator" file?"**: Type `y` and press Enter.
    - **"Do you want to disallow multiple uses of the same authentication token? (y/n)"**: Type `y` and press Enter.
    - **"By default, tokens are good for 30 seconds. Do you want to increase the time skew window to 4 minutes? (y/n)"**: Type `n` and press Enter.
    - **"Do you want to enable rate-limiting protection? (y/n)"**: Type `y` and press Enter.

3. **Scan the QR code**: Use the Google Authenticator app on your phone to scan the QR code displayed on your terminal.

## Step 3: Configure SSH to Use Google Authenticator

1. **Edit the SSH configuration file:**

    ```bash
    sudo vim /etc/pam.d/sshd
    ```

2. **Add the following line at the end of the file:**

    ```plaintext
    auth required pam_google_authenticator.so nullok
    ```

3. **Save and close the file (Ctrl+X, then Y, then Enter).**

4. **Edit the SSH daemon configuration file:**

    ```bash
    sudo vim /etc/ssh/sshd_config
    ```

5. **Find and modify the following lines:**

    - Ensure `ChallengeResponseAuthentication` is set to `yes`:

      ```plaintext
      ChallengeResponseAuthentication yes
      ```

    - Ensure `UsePAM` is set to `yes`:

      ```plaintext
      UsePAM yes
      ```

    - (Optional) If you want to require both Google Authenticator and your password, add or modify the line:

      ```plaintext
      AuthenticationMethods publickey,password publickey,keyboard-interactive
      ```

6. **Save and close the file (Ctrl+X, then Y, then Enter).**

## Step 4: Restart the SSH Service

1. **Restart the SSH service to apply the changes:**

    ```bash
    sudo systemctl restart sshd
    ```

## Step 5: Test the Configuration

1. **Open a new SSH session to your server.**

2. **Log in with your username and password.**

3. **When prompted, enter the verification code from your Google Authenticator app.**

