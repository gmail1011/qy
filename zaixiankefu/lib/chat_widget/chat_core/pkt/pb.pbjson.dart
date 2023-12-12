///
//  Generated code. Do not modify.
//  source: pb.proto
//
// @dart = 2.7
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use baseMessageDescriptor instead')
const BaseMessage$json = const {
  '1': 'BaseMessage',
  '2': const [
    const {'1': 'action', '3': 1, '4': 1, '5': 5, '10': 'action'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `BaseMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseMessageDescriptor = $convert.base64Decode('CgtCYXNlTWVzc2FnZRIWCgZhY3Rpb24YASABKAVSBmFjdGlvbhISCgRkYXRhGAIgASgMUgRkYXRh');
@$core.Deprecated('Use playerInfoFieldsDescriptor instead')
const PlayerInfoFields$json = const {
  '1': 'PlayerInfoFields',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'platId', '3': 3, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'platName', '3': 4, '4': 1, '5': 9, '10': 'platName'},
    const {'1': 'sessionId', '3': 5, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'time', '3': 6, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'avatar', '3': 7, '4': 1, '5': 9, '10': 'avatar'},
  ],
};

/// Descriptor for `PlayerInfoFields`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerInfoFieldsDescriptor = $convert.base64Decode('ChBQbGF5ZXJJbmZvRmllbGRzEg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWUSFgoGcGxhdElkGAMgASgJUgZwbGF0SWQSGgoIcGxhdE5hbWUYBCABKAlSCHBsYXROYW1lEhwKCXNlc3Npb25JZBgFIAEoCVIJc2Vzc2lvbklkEhIKBHRpbWUYBiABKANSBHRpbWUSFgoGYXZhdGFyGAcgASgJUgZhdmF0YXI=');
@$core.Deprecated('Use servicerInfoFieldsDescriptor instead')
const ServicerInfoFields$json = const {
  '1': 'ServicerInfoFields',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'time', '3': 3, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'avatar', '3': 4, '4': 1, '5': 9, '10': 'avatar'},
    const {'1': 'declaration', '3': 5, '4': 1, '5': 9, '10': 'declaration'},
    const {'1': 'sessionId', '3': 6, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ServicerInfoFields`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicerInfoFieldsDescriptor = $convert.base64Decode('ChJTZXJ2aWNlckluZm9GaWVsZHMSDgoCaWQYASABKAlSAmlkEhoKCHVzZXJuYW1lGAIgASgJUgh1c2VybmFtZRISCgR0aW1lGAMgASgDUgR0aW1lEhYKBmF2YXRhchgEIAEoCVIGYXZhdGFyEiAKC2RlY2xhcmF0aW9uGAUgASgJUgtkZWNsYXJhdGlvbhIcCglzZXNzaW9uSWQYBiABKAlSCXNlc3Npb25JZA==');
@$core.Deprecated('Use chatFieldsDescriptor instead')
const ChatFields$json = const {
  '1': 'ChatFields',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'photo', '3': 3, '4': 3, '5': 9, '10': 'photo'},
    const {'1': 'targetId', '3': 4, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'senderId', '3': 5, '4': 1, '5': 9, '10': 'senderId'},
    const {'1': 'messageId', '3': 6, '4': 1, '5': 9, '10': 'messageId'},
    const {'1': 'isRead', '3': 7, '4': 1, '5': 5, '10': 'isRead'},
    const {'1': 'username', '3': 8, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'sessionId', '3': 9, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'type', '3': 10, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'duration', '3': 11, '4': 1, '5': 3, '10': 'duration'},
  ],
};

/// Descriptor for `ChatFields`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatFieldsDescriptor = $convert.base64Decode('CgpDaGF0RmllbGRzEhIKBHRpbWUYASABKANSBHRpbWUSEgoEdGV4dBgCIAEoCVIEdGV4dBIUCgVwaG90bxgDIAMoCVIFcGhvdG8SGgoIdGFyZ2V0SWQYBCABKAlSCHRhcmdldElkEhoKCHNlbmRlcklkGAUgASgJUghzZW5kZXJJZBIcCgltZXNzYWdlSWQYBiABKAlSCW1lc3NhZ2VJZBIWCgZpc1JlYWQYByABKAVSBmlzUmVhZBIaCgh1c2VybmFtZRgIIAEoCVIIdXNlcm5hbWUSHAoJc2Vzc2lvbklkGAkgASgJUglzZXNzaW9uSWQSEgoEdHlwZRgKIAEoBVIEdHlwZRIaCghkdXJhdGlvbhgLIAEoA1IIZHVyYXRpb24=');
@$core.Deprecated('Use chatAudioDescriptor instead')
const ChatAudio$json = const {
  '1': 'ChatAudio',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'audio', '3': 3, '4': 1, '5': 9, '10': 'audio'},
    const {'1': 'targetId', '3': 4, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'senderId', '3': 5, '4': 1, '5': 9, '10': 'senderId'},
    const {'1': 'messageId', '3': 6, '4': 1, '5': 9, '10': 'messageId'},
    const {'1': 'isRead', '3': 7, '4': 1, '5': 5, '10': 'isRead'},
    const {'1': 'username', '3': 8, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'sessionId', '3': 9, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'type', '3': 10, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'duration', '3': 11, '4': 1, '5': 3, '10': 'duration'},
  ],
};

/// Descriptor for `ChatAudio`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatAudioDescriptor = $convert.base64Decode('CglDaGF0QXVkaW8SEgoEdGltZRgBIAEoA1IEdGltZRISCgR0ZXh0GAIgASgJUgR0ZXh0EhQKBWF1ZGlvGAMgASgJUgVhdWRpbxIaCgh0YXJnZXRJZBgEIAEoCVIIdGFyZ2V0SWQSGgoIc2VuZGVySWQYBSABKAlSCHNlbmRlcklkEhwKCW1lc3NhZ2VJZBgGIAEoCVIJbWVzc2FnZUlkEhYKBmlzUmVhZBgHIAEoBVIGaXNSZWFkEhoKCHVzZXJuYW1lGAggASgJUgh1c2VybmFtZRIcCglzZXNzaW9uSWQYCSABKAlSCXNlc3Npb25JZBISCgR0eXBlGAogASgFUgR0eXBlEhoKCGR1cmF0aW9uGAsgASgDUghkdXJhdGlvbg==');
@$core.Deprecated('Use chatUserInfoDescriptor instead')
const ChatUserInfo$json = const {
  '1': 'ChatUserInfo',
  '2': const [
    const {'1': 'platName', '3': 1, '4': 1, '5': 9, '10': 'platName'},
    const {'1': 'platId', '3': 2, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'sessionId', '3': 5, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'avatar', '3': 6, '4': 1, '5': 9, '10': 'avatar'},
    const {'1': 'time', '3': 7, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'msgs', '3': 8, '4': 3, '5': 11, '6': '.pb.ChatFields', '10': 'msgs'},
    const {'1': 'isFreezed', '3': 9, '4': 1, '5': 8, '10': 'isFreezed'},
  ],
};

/// Descriptor for `ChatUserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatUserInfoDescriptor = $convert.base64Decode('CgxDaGF0VXNlckluZm8SGgoIcGxhdE5hbWUYASABKAlSCHBsYXROYW1lEhYKBnBsYXRJZBgCIAEoCVIGcGxhdElkEg4KAmlkGAMgASgJUgJpZBIaCgh1c2VybmFtZRgEIAEoCVIIdXNlcm5hbWUSHAoJc2Vzc2lvbklkGAUgASgJUglzZXNzaW9uSWQSFgoGYXZhdGFyGAYgASgJUgZhdmF0YXISEgoEdGltZRgHIAEoA1IEdGltZRIiCgRtc2dzGAggAygLMg4ucGIuQ2hhdEZpZWxkc1IEbXNncxIcCglpc0ZyZWV6ZWQYCSABKAhSCWlzRnJlZXplZA==');
@$core.Deprecated('Use chatUserListDescriptor instead')
const ChatUserList$json = const {
  '1': 'ChatUserList',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.pb.ChatUserInfo', '10': 'list'},
  ],
};

/// Descriptor for `ChatUserList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatUserListDescriptor = $convert.base64Decode('CgxDaGF0VXNlckxpc3QSJAoEbGlzdBgBIAMoCzIQLnBiLkNoYXRVc2VySW5mb1IEbGlzdA==');
@$core.Deprecated('Use updateReadTypeDescriptor instead')
const UpdateReadType$json = const {
  '1': 'UpdateReadType',
  '2': const [
    const {'1': 'senderId', '3': 1, '4': 1, '5': 9, '10': 'senderId'},
    const {'1': 'targetId', '3': 2, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'msgs', '3': 3, '4': 3, '5': 9, '10': 'msgs'},
    const {'1': 'sessionId', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `UpdateReadType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateReadTypeDescriptor = $convert.base64Decode('Cg5VcGRhdGVSZWFkVHlwZRIaCghzZW5kZXJJZBgBIAEoCVIIc2VuZGVySWQSGgoIdGFyZ2V0SWQYAiABKAlSCHRhcmdldElkEhIKBG1zZ3MYAyADKAlSBG1zZ3MSHAoJc2Vzc2lvbklkGAQgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use historyMessageDescriptor instead')
const HistoryMessage$json = const {
  '1': 'HistoryMessage',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'platId', '3': 2, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'currentSessionId', '3': 3, '4': 1, '5': 9, '10': 'currentSessionId'},
  ],
};

/// Descriptor for `HistoryMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyMessageDescriptor = $convert.base64Decode('Cg5IaXN0b3J5TWVzc2FnZRIOCgJpZBgBIAEoCVICaWQSFgoGcGxhdElkGAIgASgJUgZwbGF0SWQSKgoQY3VycmVudFNlc3Npb25JZBgDIAEoCVIQY3VycmVudFNlc3Npb25JZA==');
@$core.Deprecated('Use messageListDescriptor instead')
const MessageList$json = const {
  '1': 'MessageList',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'msgs', '3': 3, '4': 3, '5': 11, '6': '.pb.ChatFields', '10': 'msgs'},
  ],
};

/// Descriptor for `MessageList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageListDescriptor = $convert.base64Decode('CgtNZXNzYWdlTGlzdBIcCglzZXNzaW9uSWQYASABKAlSCXNlc3Npb25JZBISCgR0aW1lGAIgASgDUgR0aW1lEiIKBG1zZ3MYAyADKAsyDi5wYi5DaGF0RmllbGRzUgRtc2dz');
@$core.Deprecated('Use queueInfoDescriptor instead')
const QueueInfo$json = const {
  '1': 'QueueInfo',
  '2': const [
    const {'1': 'waitCount', '3': 1, '4': 1, '5': 5, '10': 'waitCount'},
  ],
};

/// Descriptor for `QueueInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queueInfoDescriptor = $convert.base64Decode('CglRdWV1ZUluZm8SHAoJd2FpdENvdW50GAEgASgFUgl3YWl0Q291bnQ=');
@$core.Deprecated('Use bannedUserDescriptor instead')
const BannedUser$json = const {
  '1': 'BannedUser',
  '2': const [
    const {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
  ],
};

/// Descriptor for `BannedUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bannedUserDescriptor = $convert.base64Decode('CgpCYW5uZWRVc2VyEhIKBGRhdGUYASABKAlSBGRhdGU=');
@$core.Deprecated('Use enterStatusDescriptor instead')
const EnterStatus$json = const {
  '1': 'EnterStatus',
  '2': const [
    const {'1': 'senderId', '3': 1, '4': 1, '5': 9, '10': 'senderId'},
    const {'1': 'targetId', '3': 2, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    const {'1': 'sessionId', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `EnterStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enterStatusDescriptor = $convert.base64Decode('CgtFbnRlclN0YXR1cxIaCghzZW5kZXJJZBgBIAEoCVIIc2VuZGVySWQSGgoIdGFyZ2V0SWQYAiABKAlSCHRhcmdldElkEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQSHAoJc2Vzc2lvbklkGAQgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use freezePlayerDescriptor instead')
const FreezePlayer$json = const {
  '1': 'FreezePlayer',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'opUserId', '3': 3, '4': 1, '5': 9, '10': 'opUserId'},
    const {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    const {'1': 'type', '3': 5, '4': 1, '5': 5, '10': 'type'},
  ],
};

/// Descriptor for `FreezePlayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezePlayerDescriptor = $convert.base64Decode('CgxGcmVlemVQbGF5ZXISEgoEdGltZRgBIAEoA1IEdGltZRIWCgZ1c2VySWQYAiABKAlSBnVzZXJJZBIaCghvcFVzZXJJZBgDIAEoCVIIb3BVc2VySWQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24SEgoEdHlwZRgFIAEoBVIEdHlwZQ==');
@$core.Deprecated('Use evaluateScoreDescriptor instead')
const EvaluateScore$json = const {
  '1': 'EvaluateScore',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    const {'1': 'score', '3': 3, '4': 1, '5': 5, '10': 'score'},
  ],
};

/// Descriptor for `EvaluateScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateScoreDescriptor = $convert.base64Decode('Cg1FdmFsdWF0ZVNjb3JlEhwKCXNlc3Npb25JZBgBIAEoCVIJc2Vzc2lvbklkEhgKB2NvbnRlbnQYAiABKAlSB2NvbnRlbnQSFAoFc2NvcmUYAyABKAVSBXNjb3Jl');
@$core.Deprecated('Use rejectPlayerDescriptor instead')
const RejectPlayer$json = const {
  '1': 'RejectPlayer',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
  ],
};

/// Descriptor for `RejectPlayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectPlayerDescriptor = $convert.base64Decode('CgxSZWplY3RQbGF5ZXISEgoEdHlwZRgBIAEoBVIEdHlwZRISCgR0aW1lGAIgASgDUgR0aW1l');
@$core.Deprecated('Use playerInfoDescriptor instead')
const PlayerInfo$json = const {
  '1': 'PlayerInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
    const {'1': 'platId', '3': 4, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'platName', '3': 5, '4': 1, '5': 9, '10': 'platName'},
  ],
};

/// Descriptor for `PlayerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerInfoDescriptor = $convert.base64Decode('CgpQbGF5ZXJJbmZvEg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWUSFgoGYXZhdGFyGAMgASgJUgZhdmF0YXISFgoGcGxhdElkGAQgASgJUgZwbGF0SWQSGgoIcGxhdE5hbWUYBSABKAlSCHBsYXROYW1l');
@$core.Deprecated('Use playerDisconnectDescriptor instead')
const PlayerDisconnect$json = const {
  '1': 'PlayerDisconnect',
  '2': const [
    const {'1': 'playerId', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'platId', '3': 3, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'platName', '3': 4, '4': 1, '5': 9, '10': 'platName'},
    const {'1': 'playerName', '3': 5, '4': 1, '5': 9, '10': 'playerName'},
  ],
};

/// Descriptor for `PlayerDisconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerDisconnectDescriptor = $convert.base64Decode('ChBQbGF5ZXJEaXNjb25uZWN0EhoKCHBsYXllcklkGAEgASgJUghwbGF5ZXJJZBISCgR0aW1lGAIgASgDUgR0aW1lEhYKBnBsYXRJZBgDIAEoCVIGcGxhdElkEhoKCHBsYXROYW1lGAQgASgJUghwbGF0TmFtZRIeCgpwbGF5ZXJOYW1lGAUgASgJUgpwbGF5ZXJOYW1l');
@$core.Deprecated('Use playerChangRoleDescriptor instead')
const PlayerChangRole$json = const {
  '1': 'PlayerChangRole',
  '2': const [
    const {'1': 'playerId', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'playerName', '3': 2, '4': 1, '5': 9, '10': 'playerName'},
    const {'1': 'platId', '3': 3, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'platName', '3': 4, '4': 1, '5': 9, '10': 'platName'},
    const {'1': 'time', '3': 5, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'oldPType', '3': 6, '4': 1, '5': 5, '10': 'oldPType'},
    const {'1': 'currentPType', '3': 7, '4': 1, '5': 5, '10': 'currentPType'},
  ],
};

/// Descriptor for `PlayerChangRole`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerChangRoleDescriptor = $convert.base64Decode('Cg9QbGF5ZXJDaGFuZ1JvbGUSGgoIcGxheWVySWQYASABKAlSCHBsYXllcklkEh4KCnBsYXllck5hbWUYAiABKAlSCnBsYXllck5hbWUSFgoGcGxhdElkGAMgASgJUgZwbGF0SWQSGgoIcGxhdE5hbWUYBCABKAlSCHBsYXROYW1lEhIKBHRpbWUYBSABKANSBHRpbWUSGgoIb2xkUFR5cGUYBiABKAVSCG9sZFBUeXBlEiIKDGN1cnJlbnRQVHlwZRgHIAEoBVIMY3VycmVudFBUeXBl');
@$core.Deprecated('Use heartbeatDescriptor instead')
const Heartbeat$json = const {
  '1': 'Heartbeat',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 3, '10': 'time'},
  ],
};

/// Descriptor for `Heartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatDescriptor = $convert.base64Decode('CglIZWFydGJlYXQSEgoEdGltZRgBIAEoA1IEdGltZQ==');
@$core.Deprecated('Use waiterDisconnectDescriptor instead')
const WaiterDisconnect$json = const {
  '1': 'WaiterDisconnect',
  '2': const [
    const {'1': 'waiterId', '3': 1, '4': 1, '5': 9, '10': 'waiterId'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'notice', '3': 3, '4': 1, '5': 9, '10': 'notice'},
    const {'1': 'waiterName', '3': 4, '4': 1, '5': 9, '10': 'waiterName'},
  ],
};

/// Descriptor for `WaiterDisconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiterDisconnectDescriptor = $convert.base64Decode('ChBXYWl0ZXJEaXNjb25uZWN0EhoKCHdhaXRlcklkGAEgASgJUgh3YWl0ZXJJZBISCgR0aW1lGAIgASgDUgR0aW1lEhYKBm5vdGljZRgDIAEoCVIGbm90aWNlEh4KCndhaXRlck5hbWUYBCABKAlSCndhaXRlck5hbWU=');
@$core.Deprecated('Use reLoginDescriptor instead')
const ReLogin$json = const {
  '1': 'ReLogin',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'platId', '3': 4, '4': 1, '5': 9, '10': 'platId'},
  ],
};

/// Descriptor for `ReLogin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reLoginDescriptor = $convert.base64Decode('CgdSZUxvZ2luEhIKBHRpbWUYASABKANSBHRpbWUSDgoCaWQYAiABKAlSAmlkEhIKBG5hbWUYAyABKAlSBG5hbWUSFgoGcGxhdElkGAQgASgJUgZwbGF0SWQ=');
@$core.Deprecated('Use appraiseTimeOutDescriptor instead')
const AppraiseTimeOut$json = const {
  '1': 'AppraiseTimeOut',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'senderId', '3': 2, '4': 1, '5': 9, '10': 'senderId'},
    const {'1': 'targetId', '3': 3, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'time', '3': 4, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'timeDuration', '3': 5, '4': 1, '5': 3, '10': 'timeDuration'},
  ],
};

/// Descriptor for `AppraiseTimeOut`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appraiseTimeOutDescriptor = $convert.base64Decode('Cg9BcHByYWlzZVRpbWVPdXQSHAoJc2Vzc2lvbklkGAEgASgJUglzZXNzaW9uSWQSGgoIc2VuZGVySWQYAiABKAlSCHNlbmRlcklkEhoKCHRhcmdldElkGAMgASgJUgh0YXJnZXRJZBISCgR0aW1lGAQgASgDUgR0aW1lEiIKDHRpbWVEdXJhdGlvbhgFIAEoA1IMdGltZUR1cmF0aW9u');
@$core.Deprecated('Use releaseBannedDescriptor instead')
const ReleaseBanned$json = const {
  '1': 'ReleaseBanned',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'waiterId', '3': 2, '4': 1, '5': 9, '10': 'waiterId'},
    const {'1': 'playerId', '3': 3, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'platId', '3': 4, '4': 1, '5': 9, '10': 'platId'},
  ],
};

/// Descriptor for `ReleaseBanned`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseBannedDescriptor = $convert.base64Decode('Cg1SZWxlYXNlQmFubmVkEhwKCXNlc3Npb25JZBgBIAEoCVIJc2Vzc2lvbklkEhoKCHdhaXRlcklkGAIgASgJUgh3YWl0ZXJJZBIaCghwbGF5ZXJJZBgDIAEoCVIIcGxheWVySWQSFgoGcGxhdElkGAQgASgJUgZwbGF0SWQ=');
@$core.Deprecated('Use currentSessionMessageDescriptor instead')
const CurrentSessionMessage$json = const {
  '1': 'CurrentSessionMessage',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'platId', '3': 2, '4': 1, '5': 9, '10': 'platId'},
    const {'1': 'currentSessionId', '3': 3, '4': 1, '5': 9, '10': 'currentSessionId'},
  ],
};

/// Descriptor for `CurrentSessionMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List currentSessionMessageDescriptor = $convert.base64Decode('ChVDdXJyZW50U2Vzc2lvbk1lc3NhZ2USFgoGdXNlcklkGAEgASgJUgZ1c2VySWQSFgoGcGxhdElkGAIgASgJUgZwbGF0SWQSKgoQY3VycmVudFNlc3Npb25JZBgDIAEoCVIQY3VycmVudFNlc3Npb25JZA==');
@$core.Deprecated('Use ackReplyPacketDescriptor instead')
const AckReplyPacket$json = const {
  '1': 'AckReplyPacket',
  '2': const [
    const {'1': 'messageId', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    const {'1': 'sessionId', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'targetId', '3': 3, '4': 1, '5': 9, '10': 'targetId'},
    const {'1': 'senderId', '3': 4, '4': 1, '5': 9, '10': 'senderId'},
  ],
};

/// Descriptor for `AckReplyPacket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackReplyPacketDescriptor = $convert.base64Decode('Cg5BY2tSZXBseVBhY2tldBIcCgltZXNzYWdlSWQYASABKAlSCW1lc3NhZ2VJZBIcCglzZXNzaW9uSWQYAiABKAlSCXNlc3Npb25JZBIaCgh0YXJnZXRJZBgDIAEoCVIIdGFyZ2V0SWQSGgoIc2VuZGVySWQYBCABKAlSCHNlbmRlcklk');
