/**
 * Copyright 2014 Kakao Corp.
 *
 * Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*!
 @header KinsightSession.h
 카카오 플랫폼 서비스에서 제공하는 Analytics를 사용하기 위한 기본 헤더입니다. 분석용 데이타 수집을 위한 세션을 관리하고, 특정 이벤트 및 관련 정보를 수집하는 기능을 제공합니다.
 */
#import <UIKit/UIKit.h>

@protocol KinsightSessionDelegate;

@interface KinsightSession : NSObject

@property (nonatomic, assign) BOOL loggingEnabled;

#pragma mark Singleton access
+ (KinsightSession *)shared;

#pragma mark APIs
/*!
 @method resume
 @abstract 분석용 데이타 수집을 위한 세션을 시작하고, 필요한 데이타를 업로드 합니다. 세션이란 앱의 실행과 종료까지의 과정을 의미합니다. 만약 이전의 세션을 종료한 후 짧은 시간 이내에
 다른 세션을 시작하려한다면, SDK는 새로운 세션을 시작하는 대신 기존의 세션을 연장합니다.
 */
- (void)resume;

/*!
 @method close
 @abstract 데이타 수집을 위한 세션을 종료하고 전송이 가능한 데이타를 업로드 합니다.
 */
- (void)close;

/*!
 @method addEvent
 @abstract 이미 열려진 세션에 사용자의 이벤트를 기록합니다.
 @param event 기록하고자 하는 이벤트의 이름이며, null이거나 빈문자열이 아니어야 합니다.
 */
- (void)addEvent:(NSString *)event;

/*!
 @abstract 이미 열려진 세션에 사용자의 이벤트와 이벤트에 관련된 부가 속성을 기록합니다.
 @param event 기록하고자 하는 이벤트의 이름이며, null이거나 빈문자열이 아니어야 합니다.
 @param attributes 이 이벤트의 속성에 대한 키-밸류의 쌍으로 이루어진 컬렉션
 */
- (void)addEvent:(NSString *)event
      attributes:(NSDictionary *)attributes;

/*!
 @method tagScreen
 @abstract 사용된 화면(스크린)을 세션에 기록합니다.
 @param screen 기록하고자 하는 스크린(화면)의 이름이며, null이거나 빈문자열이 아니어야 합니다.
 */
- (void)tagScreen:(NSString *)screen;

/*!
 @method initialize
 @abstract 라이브러리의 사용을 위해 객체를 초기화합니다.
 */
- (void)initialize;

@end
