//
//  RouterRenderer.m
//  OSRM-iOS
//
//  Created by Romain Quidet on 05/04/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "RouteRenderer.h"

// based on
// https://svn.apache.org/repos/asf/mesos/tags/release-0.9.0-incubating-RC0/src/common/json.hpp

#ifndef JSON_OBJCRENDERER_HPP
#define JSON_OBJCRENDERER_HPP

#include "util/cast.hpp"
#include "util/string_util.hpp"

#include "osrm/json_container.hpp"

#include <iterator>
#include <ostream>
#include <string>
#include <vector>

namespace osrm
{
    namespace util
    {
        namespace json
        {
            struct ObjCRenderer
            {
                explicit ObjCRenderer(NSObject *_container, NSString *_key) {
                    container = _container;
                    key = _key;
                }

                void operator()(const String &string) const
                {
                    const auto string_to_insert = string.value;
                    NSString *objcString = [NSString stringWithUTF8String:string_to_insert.c_str()];
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:objcString
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:objcString];
                    }
                }

                void operator()(const Number &number) const
                {
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:@(number.value)
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:@(number.value)];
                    }
                }

                void operator()(const Object &object) const
                {
                    NSMutableDictionary *objcDic = [NSMutableDictionary dictionaryWithCapacity:object.values.size()];
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:objcDic
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:objcDic];
                    }

                    for (auto it : object.values)
                    {
                        NSString *first = [NSString stringWithUTF8String:(it.first).c_str()];
                        mapbox::util::apply_visitor(ObjCRenderer(objcDic, first), it.second);
                    }
                }

                void operator()(const Array &array) const
                {
                    NSMutableArray *objcArray = [NSMutableArray arrayWithCapacity:array.values.size()];
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:objcArray
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:objcArray];
                    }

                    for (auto const& value : array.values)
                    {
                        mapbox::util::apply_visitor(ObjCRenderer(objcArray, nil), value);
                    }
                }

                void operator()(const True &) const
                {
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:@(YES)
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:@(YES)];
                    }
                }

                void operator()(const False &) const
                {
                    if ([container isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)container setObject:@(NO)
                                                             forKey:key];
                    }
                    else
                    {
                        [(NSMutableArray *)container addObject:@(NO)];
                    }
                }

                void operator()(const Null &) const {  }

            private:
                NSObject *container;
                NSString *key;
            };

            inline void render(NSMutableDictionary *dic, const Object &object)
            {
                for (auto it : object.values)
                {
                    NSString *first = [NSString stringWithUTF8String:(it.first).c_str()];
                    mapbox::util::apply_visitor(ObjCRenderer(dic, first), it.second);
                }
            }
        } // namespace json
    } // namespace util
} // namespace osrm

#endif // OBJC_RENDERER

void objCRender(NSMutableDictionary *out, const osrm::util::json::Object &object)
{
    using namespace osrm;
    render(out, object);
}

