using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class VertexColor : MonoBehaviour {
  public Color color;

  void Start() {
    MeshFilter mf = GetComponent<MeshFilter> ();
    Mesh mesh = mf.mesh;

    mesh.SetColors (
      new Color[mesh.vertexCount]
      .Select (c => color)
      .ToList ()
    );
  }

}
