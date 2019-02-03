export function uploadImage(file, onSuccess, onProgress = null) {
  const { imgurApiKey } = window.Tilex.clientConfig;
  if (!imgurApiKey)
    throw new Error(
      'Imgur API Key is not set. Please update your environment variables.'
    );

  const xhr = new XMLHttpRequest();
  xhr.open('POST', 'https://api.imgur.com/3/image');
  xhr.setRequestHeader('Authorization', `Client-id ${imgurApiKey}`);
  if (onProgress) xhr.onprogress = onProgress;
  xhr.onload = () => {
    if (JSON.parse(xhr.response).data.error) {
      const error = JSON.parse(xhr.response).data.error;
      alert(`Failed to upload image to Imgur: ${error}`);
      return;
    }

    const url = JSON.parse(xhr.response).data.link;

    onSuccess(url);
  };

  const fd = new FormData();
  fd.append('image', file);
  xhr.send(fd);
}
