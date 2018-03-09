using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpDown : MonoBehaviour {


    public float Speed = 5f;

    public float Height = 0.5f;
	

	void Update () {
		
        Vector3 pos = transform.position;
       
        float newY = Mathf.Sin(Time.time * Speed);
      
        transform.position = new Vector3(pos.x, newY * Height, pos.z);
		
	}
}
