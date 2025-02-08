/// Modelo que representa la relacion de usuarios y partidos.
class Usuario_Partido {
  int idUsuario;
  int idPartido;
  int equipo;

  Usuario_Partido({
    required this.idUsuario,
    required this.idPartido,
    required this.equipo,
  });

  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "idPartido": idPartido,
      "equipo": equipo,
    };
  }
}
