using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WebcamProcess : MonoBehaviour {

    WebCamTexture webcam;
    Texture2D output;
    Color32[] data;

	// Use this for initialization
    IEnumerator Start()
    {

        WebCamDevice[] devices = WebCamTexture.devices;


        yield return Application.RequestUserAuthorization(UserAuthorization.WebCam);
        if (Application.HasUserAuthorization(UserAuthorization.WebCam))
        {
            webcam = new WebCamTexture
            {
                deviceName = WebCamTexture.devices[0].name
            };

            webcam.Play();
            //data = new Color32[webcam.width * webcam.height];
            //output = new Texture2D(webcam.width, webcam.height);
            GetComponent<Renderer>().material.mainTexture = webcam;
        }
    }
	
	// Update is called once per frame
    void Update()
    {
        

        if (data != null)
        {
            //webcam.GetPixels32(data);
            // You can play around with data however you want here.
            // Color32 has member variables of a, r, g, and b. You can read and write them however you want.
            //output.SetPixels32(data);
            //output.Apply();
        }
    }
}
