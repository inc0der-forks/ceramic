package backend.impl;

import phoenix.Batcher;

import snow.modules.opengl.GL;

class CeramicShader extends phoenix.Shader {

    public var attributeKeys:Array<String> = null;

    public var uniformKeys:Array<String> = null;

    override public function link():Bool {

        program = GL.createProgram();

        GL.attachShader(program, vert_shader);
        GL.attachShader(program, frag_shader);

        /*GL.linkProgram(program);

        var na = GL.getProgramParameter(program, GL.ACTIVE_ATTRIBUTES);
        trace(na + ' attributes');
        for (i in 0...na) {
            var a = GL.getActiveAttrib(program, i);
            trace(i + ' ' + a.size + ' ' + glTypeToString(a.type) + ' ' + a.name);
        }
        var nu = GL.getProgramParameter(program, GL.ACTIVE_UNIFORMS);
        trace(nu + ' uniforms');
        for (i in 0...nu) {
            var u = GL.getActiveUniform(program, i);
            trace(i + ' ' + u.size + ' ' + glTypeToString(u.type) + ' ' + u.name);
        }*/

            //Now we want to ensure that our locations are static
        GL.bindAttribLocation( program, Batcher.vert_attribute,    'vertexPosition');
        GL.bindAttribLocation( program, Batcher.tcoord_attribute,  'vertexTCoord');
        GL.bindAttribLocation( program, Batcher.color_attribute,   'vertexColor');

        GL.linkProgram(program);

        if( GL.getProgramParameter(program, GL.LINK_STATUS) == 0) {
            add_log("\tFailed to link shader program:");
            add_log( format_log(GL.getProgramInfoLog(program)) );
            GL.deleteProgram(program);
            program = null;
            return false;
        }

            //first bind it
        use();

            //:todo: this is being refactored for the new
            //way more flexible shaders and rendering :}

                //Matrices
            if(!no_default_uniforms) {

                proj_attribute = location('projectionMatrix');
                view_attribute = location('modelViewMatrix');

                var _tex0_attribute = location( 'tex0' );
                var _tex1_attribute = location( 'tex1' );
                var _tex2_attribute = location( 'tex2' );
                var _tex3_attribute = location( 'tex3' );
                var _tex4_attribute = location( 'tex4' );
                var _tex5_attribute = location( 'tex5' );
                var _tex6_attribute = location( 'tex6' );
                var _tex7_attribute = location( 'tex7' );

                if(_tex0_attribute != null) GL.uniform1i( _tex0_attribute, 0 );
                if(_tex1_attribute != null) GL.uniform1i( _tex1_attribute, 1 );
                if(_tex2_attribute != null) GL.uniform1i( _tex2_attribute, 2 );
                if(_tex3_attribute != null) GL.uniform1i( _tex3_attribute, 3 );
                if(_tex4_attribute != null) GL.uniform1i( _tex4_attribute, 4 );
                if(_tex5_attribute != null) GL.uniform1i( _tex5_attribute, 5 );
                if(_tex6_attribute != null) GL.uniform1i( _tex6_attribute, 6 );
                if(_tex7_attribute != null) GL.uniform1i( _tex7_attribute, 7 );

            }

        return true;

    } //link

/// Internal

    static function glTypeToString(inType:Int):String {

        return switch (inType) {
            case GL.BYTE: 'BYTE';
            case GL.UNSIGNED_BYTE: 'UNSIGNED_BYTE';
            case GL.SHORT: 'SHORT';
            case GL.UNSIGNED_SHORT: 'UNSIGNED_SHORT';
            case GL.INT: 'INT';
            case GL.BOOL: 'BOOL';
            case GL.UNSIGNED_INT: 'UNSIGNED_INT';
            case GL.FLOAT: 'FLOAT';
            case GL.FLOAT_VEC2: 'FLOAT_VEC2';
            case GL.FLOAT_VEC3: 'FLOAT_VEC3';
            case GL.FLOAT_VEC4: 'FLOAT_VEC4';
            case GL.INT_VEC2: 'INT_VEC2';
            case GL.INT_VEC3: 'INT_VEC3';
            case GL.INT_VEC4: 'INT_VEC4';
            case GL.BOOL_VEC2: 'BOOL_VEC2';
            case GL.BOOL_VEC3: 'BOOL_VEC3';
            case GL.BOOL_VEC4: 'BOOL_VEC3';
            case GL.FLOAT_MAT2: 'FLOAT_MAT2';
            case GL.FLOAT_MAT3: 'FLOAT_MAT3';
            case GL.FLOAT_MAT4: 'FLOAT_MAT4';
            case GL.SAMPLER_2D: 'SAMPLER_2D';
            case GL.SAMPLER_CUBE: 'SAMPLER_CUBE';
            default: 'unknown';
        }

    } //glTypeToString

} //CeramicShader
