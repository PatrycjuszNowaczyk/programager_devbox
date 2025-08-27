FROM node:20.17.0

# ________________________________________________________________________________
# SETTING USER ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# --------------------------------------------------------------------------------

# Create a non-root user with a specific UID and GID to match your local user
ARG USERNAME=node

ARG GROUP=node

# Replace with your local group ID, or use an ARG to pass it in build time
ARG UID=1000

# Replace with your local group ID, or use an ARG to pass it in build time
ARG GID=1000

# Rename user and group "node" to "patrycjusz" and move home directory
RUN groupmod -n ${GROUP} node
RUN usermod -l ${USERNAME} -d /home/${USERNAME} -m node

# Create directory and set the ownership of the /var/www directory to the non-root user
RUN mkdir -p /var/www
RUN chown -R ${UID}:${GID} /var/www

# Switch to the non-root user
USER ${UID}
