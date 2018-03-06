﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObj : MonoBehaviour {

    public float rotationsPerMinute = 10.0f;
	

	void Update () {
        transform.Rotate(0, 6.0f * rotationsPerMinute * Time.deltaTime, 0);		
	}
}
