/**
 *  Copyright 2019 Martynas Jusevičius <martynas@atomgraph.com>
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package com.atomgraph.linkeddatahub.server.mapper.auth.webid;

import com.atomgraph.core.MediaTypes;
import com.atomgraph.linkeddatahub.server.exception.auth.webid.WebIDDelegationException;
import com.atomgraph.server.mapper.ExceptionMapperBase;
import jakarta.inject.Inject;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import org.apache.jena.rdf.model.ResourceFactory;

/**
 * JAX-RS mapper for WebID delegation exceptions.
 * 
 * @author Martynas Jusevičius {@literal <martynas@atomgraph.com>}
 */
public class WebIDDelegationExceptionMapper  extends ExceptionMapperBase implements ExceptionMapper<WebIDDelegationException>
{

    /**
     * Constructs mapper from media types.
     * 
     * @param mediaTypes registry of readable/writable media types
     */
    @Inject
    public WebIDDelegationExceptionMapper(MediaTypes mediaTypes)
    {
        super(mediaTypes);
    }

    @Override
    public Response toResponse(WebIDDelegationException ex)
    {
        return getResponseBuilder(toResource(ex, Response.Status.BAD_REQUEST,
                    ResourceFactory.createResource("http://www.w3.org/2011/http-statusCodes#BadRequest")). // not the most accurate code for WebID error
                getModel()).
            status(Response.Status.BAD_REQUEST).
            build();
    }
    
}