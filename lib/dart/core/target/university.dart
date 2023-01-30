import 'package:orginone/dart/base/enumeration/target_type.dart';
import 'package:orginone/dart/core/target/company.dart';

class University extends Company {
  University(super.target);

  @override
  get subTypes => <TargetType>[
        TargetType.group,
        TargetType.jobCohort,
        TargetType.office,
        TargetType.working,
        TargetType.section,
        TargetType.college,
        TargetType.laboratory,
      ];
}