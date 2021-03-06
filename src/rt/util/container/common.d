/**
 * Common code for writing containers.
 *
 * Copyright: Copyright Martin Nowak 2013.
 * License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Martin Nowak
 */
module rt.util.container.common;

import core.stdc.stdlib : malloc, realloc;
public import core.stdc.stdlib : free;

void* xrealloc(void* ptr, size_t sz)
{
    import core.exception;

    if (!sz) { .free(ptr); return null; }
    if (auto nptr = .realloc(ptr, sz)) return nptr;
    .free(ptr); onOutOfMemoryError();
    assert(0);
}

void* xmalloc(size_t sz) nothrow
{
    import core.exception;
    if (auto nptr = .malloc(sz))
        return nptr;
    onOutOfMemoryError();
    assert(0);
}

void destroy(T)(ref T t) if (is(T == struct))
{
    object.destroy(t);
}

void destroy(T)(ref T t) if (!is(T == struct))
{
    t = T.init;
}

void initialize(T)(ref T t) if (is(T == struct))
{
    import core.stdc.string;
    if(auto p = typeid(T).init().ptr)
        memcpy(&t, p, T.sizeof);
    else
        memset(&t, 0, T.sizeof);
}

void initialize(T)(ref T t) if (!is(T == struct))
{
    t = T.init;
}

version (unittest) struct RC
{
    this(size_t* cnt) { ++*(_cnt = cnt); }
    ~this() { if (_cnt) --*_cnt; }
    this(this) { if (_cnt) ++*_cnt; }
    size_t* _cnt;
}
