using UnityEngine;

public class Cube : MonoBehaviour {
	public float rotateSpeedX = 10f;
	public float rotateSpeedY = 10f;
	public float rotateSpeedZ = 10f;

	void Update () {
		transform.Rotate(new Vector3(rotateSpeedX, rotateSpeedY, rotateSpeedZ) * Time.deltaTime);
	}
}
