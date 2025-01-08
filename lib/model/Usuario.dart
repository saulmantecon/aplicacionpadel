class Usuario {
  int idUsuario;
  String nombreUsuario;
  String nombre;
  String apellido;
  int edad;
  int puntos;

  // Constructor para inicializar los campos
  Usuario({

    required this.idUsuario,
    required this.nombreUsuario,
    required this.nombre,
    required this.apellido,
    required this.edad,
    this.puntos = 0,
  });

  // Método para convertir la instancia de la clase a un Map para almacenarla en la base de datos
  Map<String, dynamic> toMap() {
    return {
      "nombreUsuario": nombreUsuario,
      "nombre": nombre,
      "apellido": apellido,
      "edad": edad,
      "puntos": puntos,        // También incluimos 'puntos' en el Map
    };
  }

  // Método para crear un objeto 'Usuario' desde un Map (de la base de datos)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      nombreUsuario: map["nombreUsuario"],
      nombre: map['nombre'],
      apellido: map['apellido'],
      edad: map['edad'],
      puntos: map['puntos'] ?? 0,  // Si no hay 'puntos', asignar 0 como valor predeterminado
    );
  }
}
