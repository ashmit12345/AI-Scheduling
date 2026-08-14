/// Represents the access level of a [UserModel] within the scheduling system.
///
/// - [admin]  : Full system access — manages users, resources, and settings.
/// - [host]   : Can create and manage official schedules for an organization.
/// - [viewer] : Can view schedules and manage only personal scheduling.
enum UserRole {
  admin,
  host,
  viewer;

  /// Human-readable label used in UI (dropdowns, badges, dashboards).
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.host:
        return 'Host';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  /// Parses a role from a stored/serialized string (case-insensitive).
  /// Falls back to [UserRole.viewer] for unknown values so the app never
  /// crashes on unexpected backend data.
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.viewer,
    );
  }
}

/// Core user entity for the AI-Powered Intelligent Scheduling System.
///
/// Immutable by design — use [copyWith] to derive modified instances,
/// which plays well with Provider/ChangeNotifier state updates.
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String? ?? 'viewer'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserModel(id: $id, name: $name, role: ${role.label})';
}

