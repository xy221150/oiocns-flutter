// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter/material.dart' show debugPrint;
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/instance_task_entity.dart';
import 'package:orginone/api_resp/record_task_entity.dart';
import 'package:orginone/api_resp/task_entity.dart';

JsonConvert jsonConvert = JsonConvert();
typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);

class JsonConvert {
	static final Map<String, JsonConvertFunction> _convertFuncMap = {
		(ApiResp).toString(): ApiResp.fromJson,
		(InstanceTaskEntity).toString(): InstanceTaskEntity.fromJson,
		(InstanceTaskFlowTasks).toString(): InstanceTaskFlowTasks.fromJson,
		(InstanceTaskFlowDefine).toString(): InstanceTaskFlowDefine.fromJson,
		(InstanceTaskFlowRelation).toString(): InstanceTaskFlowRelation.fromJson,
		(RecordTaskEntity).toString(): RecordTaskEntity.fromJson,
		(RecordTaskFlowTask).toString(): RecordTaskFlowTask.fromJson,
		(RecordTaskFlowTaskFlowNode).toString(): RecordTaskFlowTaskFlowNode.fromJson,
		(RecordTaskFlowTaskFlowInstance).toString(): RecordTaskFlowTaskFlowInstance.fromJson,
		(RecordTaskFlowTaskFlowInstanceFlowRelation).toString(): RecordTaskFlowTaskFlowInstanceFlowRelation.fromJson,
		(TaskEntity).toString(): TaskEntity.fromJson,
		(TaskFlowNode).toString(): TaskFlowNode.fromJson,
		(TaskFlowInstance).toString(): TaskFlowInstance.fromJson,
		(TaskFlowInstanceFlowRelation).toString(): TaskFlowInstanceFlowRelation.fromJson,
	};

  T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return asT<T>(value);
  }

  List<T?>? convertList<T>(List<dynamic>? value) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => asT<T>(e)).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => asT<T>(e)!).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  T? asT<T extends Object?>(dynamic value) {
    if(value == null){
      return null;
    }
    if (value is T) {
      return value;
    }
    final String type = T.toString();
    try {
      final String valueS = value.toString();
      if (type == "String") {
        return valueS as T;
      } else if (type == "int") {
        final int? intValue = int.tryParse(valueS);
        if (intValue == null) {
          return double.tryParse(valueS)?.toInt() as T?;
        } else {
          return intValue as T;
        }
      } else if (type == "double") {
        return double.parse(valueS) as T;
      } else if (type == "DateTime") {
        return DateTime.parse(valueS) as T;
      } else if (type == "bool") {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else if (type == "Map" || type.startsWith("Map<")) {
        return value as T;
      } else {
        if (_convertFuncMap.containsKey(type)) {
          return _convertFuncMap[type]!(value) as T;
        } else {
          throw UnimplementedError('$type unimplemented');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return null;
    }
  }

	//list is returned by type
	static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
		if(<ApiResp>[] is M){
			return data.map<ApiResp>((Map<String, dynamic> e) => ApiResp.fromJson(e)).toList() as M;
		}
		if(<InstanceTaskEntity>[] is M){
			return data.map<InstanceTaskEntity>((Map<String, dynamic> e) => InstanceTaskEntity.fromJson(e)).toList() as M;
		}
		if(<InstanceTaskFlowTasks>[] is M){
			return data.map<InstanceTaskFlowTasks>((Map<String, dynamic> e) => InstanceTaskFlowTasks.fromJson(e)).toList() as M;
		}
		if(<InstanceTaskFlowDefine>[] is M){
			return data.map<InstanceTaskFlowDefine>((Map<String, dynamic> e) => InstanceTaskFlowDefine.fromJson(e)).toList() as M;
		}
		if(<InstanceTaskFlowRelation>[] is M){
			return data.map<InstanceTaskFlowRelation>((Map<String, dynamic> e) => InstanceTaskFlowRelation.fromJson(e)).toList() as M;
		}
		if(<RecordTaskEntity>[] is M){
			return data.map<RecordTaskEntity>((Map<String, dynamic> e) => RecordTaskEntity.fromJson(e)).toList() as M;
		}
		if(<RecordTaskFlowTask>[] is M){
			return data.map<RecordTaskFlowTask>((Map<String, dynamic> e) => RecordTaskFlowTask.fromJson(e)).toList() as M;
		}
		if(<RecordTaskFlowTaskFlowNode>[] is M){
			return data.map<RecordTaskFlowTaskFlowNode>((Map<String, dynamic> e) => RecordTaskFlowTaskFlowNode.fromJson(e)).toList() as M;
		}
		if(<RecordTaskFlowTaskFlowInstance>[] is M){
			return data.map<RecordTaskFlowTaskFlowInstance>((Map<String, dynamic> e) => RecordTaskFlowTaskFlowInstance.fromJson(e)).toList() as M;
		}
		if(<RecordTaskFlowTaskFlowInstanceFlowRelation>[] is M){
			return data.map<RecordTaskFlowTaskFlowInstanceFlowRelation>((Map<String, dynamic> e) => RecordTaskFlowTaskFlowInstanceFlowRelation.fromJson(e)).toList() as M;
		}
		if(<TaskEntity>[] is M){
			return data.map<TaskEntity>((Map<String, dynamic> e) => TaskEntity.fromJson(e)).toList() as M;
		}
		if(<TaskFlowNode>[] is M){
			return data.map<TaskFlowNode>((Map<String, dynamic> e) => TaskFlowNode.fromJson(e)).toList() as M;
		}
		if(<TaskFlowInstance>[] is M){
			return data.map<TaskFlowInstance>((Map<String, dynamic> e) => TaskFlowInstance.fromJson(e)).toList() as M;
		}
		if(<TaskFlowInstanceFlowRelation>[] is M){
			return data.map<TaskFlowInstanceFlowRelation>((Map<String, dynamic> e) => TaskFlowInstanceFlowRelation.fromJson(e)).toList() as M;
		}

		debugPrint("${M.toString()} not found");
	
		return null;
}

	static M? fromJsonAsT<M>(dynamic json) {
		if (json is List) {
			return _getListChildType<M>(json.map((e) => e as Map<String, dynamic>).toList());
		} else {
			return jsonConvert.asT<M>(json);
		}
	}
}