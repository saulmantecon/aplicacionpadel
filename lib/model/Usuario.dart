class Usuario {
  int idUsuario;
  String nombreUsuario;
  String contrasena;
  String nombre;
  String apellido;
  int edad;
  int puntos;
  String imagen;

  // Constructor para inicializar los campos
  Usuario({

    required this.idUsuario,
    required this.nombreUsuario,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.edad,
    this.puntos = 0,
    required this.imagen
  });




  Map<String, dynamic> toMap() {
    return {
      "nombreUsuario": nombreUsuario,
      "contrasena": contrasena,
      "nombre": nombre,
      "apellido": apellido,
      "edad": edad,
      "puntos": puntos,
      "imagen" : imagen
    };
  }

  // Método para crear un objeto 'Usuario' desde un Map (de la base de datos)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      nombreUsuario: map["nombreUsuario"],
      contrasena: map["contrasena"],
      nombre: map['nombre'],
      apellido: map['apellido'],
      edad: map['edad'],
      puntos: map['puntos'] ?? 0,// Si no hay 'puntos', asignar 0 como valor predeterminado
      imagen: map["imagen"]
    );
  }

  @override
  String toString() {
    return 'Usuario{idUsuario: $idUsuario, nombreUsuario: $nombreUsuario, nombre: $nombre, apellido: $apellido, edad: $edad, puntos: $puntos}';
  }
}
