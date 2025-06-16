import 'package:flutter/foundation.dart';
import 'profile_models.dart';

class ProfileStatusManager extends ChangeNotifier {
  static final ProfileStatusManager _instance =
      ProfileStatusManager._internal();
  factory ProfileStatusManager() => _instance;
  ProfileStatusManager._internal();

  final Map<String, ProfileStatus> _profileStatuses = {};

  ProfileStatus getProfileStatus(String profileId) {
    return _profileStatuses[profileId] ?? ProfileStatus.pending;
  }

  void updateProfileStatus(String profileId, ProfileStatus status) {
    _profileStatuses[profileId] = status;
    notifyListeners();
  }

  void approveProfile(String profileId) {
    updateProfileStatus(profileId, ProfileStatus.approved);
  }

  void declineProfile(String profileId) {
    updateProfileStatus(profileId, ProfileStatus.declined);
  }

  void resetProfileStatus(String profileId) {
    updateProfileStatus(profileId, ProfileStatus.pending);
  }

  Map<String, ProfileStatus> get allProfileStatuses =>
      Map.unmodifiable(_profileStatuses);

  bool isProfileProcessed(String profileId) {
    final status = getProfileStatus(profileId);
    return status == ProfileStatus.approved || status == ProfileStatus.declined;
  }

  int getProfileCountByStatus(ProfileStatus status) {
    return _profileStatuses.values.where((s) => s == status).length;
  }

  void clearAllStatuses() {
    _profileStatuses.clear();
    notifyListeners();
  }
}
