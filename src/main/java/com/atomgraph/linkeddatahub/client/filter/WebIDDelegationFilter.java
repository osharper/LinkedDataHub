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
package com.atomgraph.linkeddatahub.client.filter;

import com.atomgraph.linkeddatahub.model.Agent;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.ClientRequest;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.filter.ClientFilter;

/**
 * Client filter that delegates WebID identity.
 * 
 * @author Martynas Jusevičius {@literal <martynas@atomgraph.com>}
 */
public class WebIDDelegationFilter extends ClientFilter
{

    public static final String ON_BEHALF_OF = "On-Behalf-Of";
    
    private final Agent agent;
    
    public WebIDDelegationFilter(Agent agent)
    {
        this.agent = agent;
    }
    
    @Override
    public ClientResponse handle(ClientRequest cr) throws ClientHandlerException
    {
        cr.getHeaders().add(ON_BEHALF_OF, getAgent().getURI());

        return getNext().handle(cr);
    }
    
    public Agent getAgent()
    {
        return agent;
    }
    
}
