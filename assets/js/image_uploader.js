export function uploadImage(file, onSuccess, onError) {
  const { imgurApiKey } = window.Tilex.clientConfig;
  if (!imgurApiKey) {
    onError({ showAlert: false });
    throw new Error(
      'Imgur API Key is not set. Please update your environment variables.'
    );
  }

  const xhr = new XMLHttpRequest();
  xhr.open('POST', 'https://api.imgur.com/3/image', true);
  xhr.setRequestHeader('Authorization', `Client-id ${imgurApiKey}`);
  xhr.onload = () => {
    const parsedResponse = JSON.parse(xhr.response);

    if (xhr.status > 201 || parsedResponse.data.error) {
      onError();
      return;
    }

    const url = parsedResponse.data.link;

    onSuccess(url);
  };

  xhr.onerror = onError;

  const fd = new FormData();
  fd.append('image', file);
  xhr.send(fd);
}
